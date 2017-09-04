class MaterialCategoriesController < ApplicationController
  unloadable

  layout 'admin'

  before_action :require_admin

  def new
    @category = MaterialCategory.new
  end

  def create
    @category = MaterialCategory.new(params[:material_categories])
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action =>"plugin", :id => "redmine_materials", :controller => "settings", :tab => 'material_categories'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = MaterialCategory.find(params[:id])
  end

  def update
    @category = MaterialCategory.find(params[:id])
    if @category.update_attributes(params[:material_category])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action =>"plugin", :id => "redmine_materials", :controller => "settings", :tab => 'material_categories'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = MaterialCategory.find(params[:id])
    @materials_count = @category.materials.count if @category.present?
    if @materials_count == 0 || params[:todo] || api_request?
      reassign_to = nil
      if params[:reassign_to_id] && (params[:todo] == 'reassign' || params[:todo].blank?)
        reassign_to = MaterialCategory.find(params[:reassign_to_id])
      end
      @category.destroy(reassign_to)
      respond_to do |format|
        format.html { redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_materials', :tab => 'material_categories' }
        format.api { render_api_ok }
      end
      return
    end
    @categories = MaterialCategory.all - [@category]
  end

end
