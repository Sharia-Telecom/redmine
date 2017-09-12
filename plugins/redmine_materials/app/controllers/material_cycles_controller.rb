class MaterialCyclesController < ApplicationController
  before_action :find_project_by_project_id, :only => [:new, :entry, :middle, :exit, :create, :show, :edit, :destroy, :update]
  before_action :find_material_by_material_id, :only => [:index, :new, :entry, :middle, :exit, :create, :show, :edit, :destroy, :update]
  before_action :set_material_cycle, only: [:show, :edit, :update, :destroy]
  before_action :find_optional_project, :only => :index

  helper :issues
  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :material_queries
  include MaterialQueriesHelper
  
  def new
    @material_cycle = @material.material_cycles.new
    @material_cycle.project = @project
    
    (render_403; return false) unless @material_cycle.creatable_by?(User.current, @project)
    
    # set default
    @material_cycle.author = User.current
  end
  
  def entry
    (render_403; return false) unless @material.can_cycle_entry?

    @material_cycle = @material.material_cycles.build
    @material_cycle.project = @project
    (render_403; return false) unless @material_cycle.creatable_by?(User.current, @project)

    redirect_to new_project_issue_path(@project, :material_cycle_stage => MaterialCycle::STAGE_ENTRY, :material_id => @material.id)
  end

  def middle
    (render_403; return false) unless @material.can_cycle_middle?

    @material_cycle = @material.material_cycles.build
    @material_cycle.project = @project
    
    (render_403; return false) unless @material_cycle.creatable_by?(User.current, @project)
    
    redirect_to new_project_issue_path(@project, :material_cycle_stage => MaterialCycle::STAGE_MIDDLE, :material_id => @material.id)
  end
  
  def exit
    (render_403; return false) unless @material.can_cycle_exit?
    
    @material_cycle = @material.material_cycles.build
    @material_cycle.project = @project
    
    (render_403; return false) unless @material_cycle.creatable_by?(User.current, @project)
    
    redirect_to new_project_issue_path(@project, :material_cycle_stage => MaterialCycle::STAGE_EXIT, :material_id => @material.id)
  end

  def index
    @query = MaterialCycleQuery.build_from_params(params, :project => @project, :name => '_')
    # retrieve_query('material_cycle')
    sort_init(@query.sort_criteria.empty? ? [['updated_date', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    
    scope = material_cycle_scope(:order => sort_clause).
      includes(:project, :material, :issue)

    respond_to do |format|
      format.html {
        @material_cycles_count = scope.count
        @material_cycles_pages = Paginator.new @material_cycles_count, per_page_option, params['page']
        @material_cycles = scope.offset(@material_cycles_pages.offset).limit(@material_cycles_pages.per_page).to_a
        render :layout => !request.xhr?
      }
      # format.api
      # format.csv { send_data(material_cycles_to_csv(@material_cycles), :type => 'text/csv; header=present', :filename => 'material_cycles.csv') }
    end
  end


  def edit
    (render_403; return false) unless @material_cycle.editable_by?(User.current)
  end
  
  def show
    (render_403; return false) unless @material_cycle.visible?(User.current)
  end
  
  def destroy
    (render_403; return false) unless @material_cycle.destroyable_by?(User.current)
    
    if @material_cycle.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    
    respond_to do |format|
      format.html { redirect_to :action => "index", :project_id => @material.project }
      format.api  { head :ok }
    end
  end
  
  def create
    @material_cycle = @material.material_cycles.build(material_cycle_params)
    (render_403; return false) unless @material_cycle.creatable_by?(User.current, @project)
    @material_cycle.author = User.current
    @material_cycle.project = @project
    stage = params[:stage]
    @material_cycle.stage = stage
    
    respond_to do |format|
      if @material_cycle.save
        flash[:notice] = l(:notice_material_cycle_create_success)
        format.html { redirect_to :action => "show", :id => @material_cycle}
        format.json { render :show, status: :created, location: @material_cycle }
      else
        format.html { render :new }
        format.json { render json: @material_cycle.errors, status: l(:notice_material_cycle_create_fail) }
      end
    end
  end
  
  def update
    (render_403; return false) unless @material_cycle.editable_by?(User.current)
    if @material_cycle.update_attributes(material_cycle_params)
      flash[:notice] = l(:notice_material_cycle_update_success)
      respond_to do |format|
        format.html { redirect_to :action => "show", :id => @material_cycle }
        format.api  { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit"}
        format.api  { render_validation_errors(@material_cycle) }
      end
    end
  end
  
  
  private 
      def material_cycle_scope(options={})
        scope = @query.results_scope(options)
        if @material
          scope = scope.on_material(@material)
        end
        scope
      end
      
      def material_cycle_params
      params.require(:material_cycle).permit( :project_id,
                                      :material_id,
                                      :issue_id,                                   :brand,
                                      :stage,
                                      :event_type,
                                      :order_no,
                                      :direction,
                                      :value,
                                      :location,
                                      :warehouse_id,
                                      :outsider,
                                      :purpose)
    end

    def find_material_by_material_id
        # Find material of id params[:project_id]
      @material = Material.find(params[:material_id])
      rescue ActiveRecord::RecordNotFound
      render_404
    end
    
    def set_material_cycle
      @material_cycle = MaterialCycle.find(params[:id])
    end
end
