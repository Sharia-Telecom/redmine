class WarehousesController < ApplicationController
  unloadable

  layout 'admin'

  before_action :require_admin


  def new
    @warehouse = Warehouse.new
    @warehouse.type = 0
    @warehouse.status = 0
  end

  def create
    @warehouse = Warehouse.new(params[:warehouses])
    @warehouse.author = User.current
    if @warehouse.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action =>"plugin", :id => "redmine_materials", :controller => "settings", :tab => 'warehouses'
    else
      @warehouse.type = 0
      @warehouse.status = 0
      render :action => 'new'
    end
  end

  def edit
    @warehouse = Warehouse.find(params[:id])
  end

  def update
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.update_attributes(params[:warehouse])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action =>"plugin", :id => "redmine_materials", :controller => "settings", :tab => 'warehouses'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    
    respond_to do |format|
      format.html { redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_materials', :tab => 'warehouses' }
      format.api { render_api_ok }
    end
  end
end
