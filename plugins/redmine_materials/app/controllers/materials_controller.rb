class MaterialsController < ApplicationController
  before_action :find_project_by_project_id, :only => [:new, :create, :show, :edit, :destroy, :update]
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :find_optional_project, :only => :index
  
  helper :materials
  include MaterialsHelper
  helper :issues
  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :attachments
  include AttachmentsHelper
  helper :material_queries
  include MaterialQueriesHelper
  
  def index
    retrieve_query('material')
    sort_init(@query.sort_criteria.empty? ? [['purchase_date', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    
    case params[:format]
    when 'csv', 'pdf'
      @limit = Setting.issues_export_limit.to_i
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit
    else
      @limit = per_page_option
    end
    
    @materials = @query.results_scope(
      :include => :projects,
      :search => params[:search],
      :order => sort_clause,
      :limit  =>  @limit,
      :offset =>  @offset
    )
    
    
    scope = material_scope(:order => sort_clause).
      includes(:project)

    @materials_count = scope.count
    
    @materials_pages = Paginator.new(@materials_count, @limit, params['page'])


    respond_to do |format|
      format.html {
        @materials = scope.offset(@materials_pages.offset).limit(@materials_pages.per_page).to_a
        render :layout => !request.xhr?
      }
      format.api
      format.csv { send_data(materials_to_csv(@materials), :type => 'text/csv; header=present', :filename => 'materials.csv') }
    end
  end


  def new
    @material = @project.materials.new
    parent_id = params[:parent_id]
    if !parent_id.nil?
      @material.parent_material_id = parent_id
    end
    (render_403; return false) unless @material.creatable_by?(User.current, @project)
    
    # set default
    @material.status = '0'
    @material.amount = 1
    @material.property = '0'
  end


  def edit
    (render_403; return false) unless @material.editable_by?(User.current)
  end


  def show
    (render_403; return false) unless @material.visible?(User.current)
    @comments = @material.comments.to_a
    @comments.reverse! if User.current.wants_comments_in_reverse_order?
  end
  
  def destroy
    (render_403; return false) unless @material.destroyable_by?(User.current)
    
    if @material.destroy
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
    @material = @project.materials.build(material_params)
    (render_403; return false) unless @material.creatable_by?(User.current, @project)
    @material.author = User.current
    @material.project = @project
    update_handover_at
    update_location_since
    update_use_since
    update_purchase_at
    
    respond_to do |format|
      if @material.save
        attachments = Attachment.attach_files(@material, (params[:attachments] || (params[:material] && params[:material][:uploads])))
        render_attachment_warning_if_needed(@material)

        flash[:notice] = l(:notice_material_create_success)
        format.html { redirect_to :action => "show", :id => @material}
        format.json { render :show, status: :created, location: @material }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: l(:notice_material_create_fail) }
      end
    end
  end
  
  def update
    (render_403; return false) unless @material.editable_by?(User.current)
    if @material.update_attributes(material_params)
      update_handover_at
      update_location_since
      update_use_since
      update_purchase_at
      attachments = Attachment.attach_files(@material, (params[:attachments] || (params[:material] && params[:material][:uploads])))
      render_attachment_warning_if_needed(@material)
      flash[:notice] = l(:notice_material_update_success)
      respond_to do |format|
        format.html { redirect_to :action => "show", :id => @material }
        format.api  { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit"}
        format.api  { render_validation_errors(@material) }
      end
    end
  end
  
  private
    def material_scope(options={})
      scope = @query.results_scope(options)
    end
    
    def material_params
      params.require(:material).permit( :project_id,
                                      :name,
                                      :inner_code,
                                      :brand,
                                      :device_no,
                                      :category_id,
                                      :parent_material_id,
                                      :amount,
                                      :original_value,
                                      :current_value,
                                      :use_since,
                                      :user_id,
                                      :handover_id,
                                      :author_id,
                                      :owner_id,
                                      :responsible_by_id,
                                      :purchaser_id,
                                      :purchase_at,
                                      :use_since,
                                      :handover_at,
                                      :location,
                                      :location_since,
                                      :detail,
                                      :property,
                                      :status,
                                      :remark)
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end
    
    def update_handover_at
      if params[:handover_at_time] && params[:handover_at_time].to_s.gsub(/\s/, "").match(/^(\d{1,2}):(\d{1,2})$/)
        handover_at = @material.handover_at.change({:hour => $1.to_i % 24, :min => $2.to_i % 60}) if @material.handover_at.present?
        if @material.new_record?
          @material.handover_at = handover_at
        else
          @material.update_attribute(:handover_at, handover_at)
        end
      end
    end
    
    def update_use_since
      if params[:use_since_time] && params[:use_since_time].to_s.gsub(/\s/, "").match(/^(\d{1,2}):(\d{1,2})$/)
        use_since = @material.use_since.change({:hour => $1.to_i % 24, :min => $2.to_i % 60}) if @material.use_since.present?
        if @material.new_record?
          @material.use_since = use_since
        else
          @material.update_attribute(:use_since, use_since)
        end
      end
    end
    
    def update_purchase_at
      if params[:purchase_at_time] && params[:purchase_at_time].to_s.gsub(/\s/, "").match(/^(\d{1,2}):(\d{1,2})$/)
        purchase_at = @material.purchase_at.change({:hour => $1.to_i % 24, :min => $2.to_i % 60}) if @material.purchase_at.present?
        if @material.new_record?
          @material.purchase_at = purchase_at
        else
          @material.update_attribute(:purchase_at, purchase_at)
        end
      end
    end
    
    
    def update_location_since
      if params[:location_since_time] && params[:location_since_time].to_s.gsub(/\s/, "").match(/^(\d{1,2}):(\d{1,2})$/)
        location_since = @material.location_since.change({:hour => $1.to_i % 24, :min => $2.to_i % 60}) if @material.location_since.present?
        if @material.new_record?
          @material.location_since = location_since
        else
          @material.update_attribute(:location_since, location_since)
        end
      end
    end
end