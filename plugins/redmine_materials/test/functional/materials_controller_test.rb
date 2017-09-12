require File.expand_path('../../test_helper', __FILE__)

class MaterialsControllerTest < ActionController::TestCase
    fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :queries
  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/',
                                          :materials)

  def setup
    @project = Project.find(1)
    @project.enable_module!(:redmine_materials)
    User.current = User.find(1)
    @request.session[:user_id] = 1
  end
  
   test "module permition" do
    @project.disable_module!(:redmine_materials)
    get :show, :project_id => @project, :id => 1
    assert_response 403
    get :edit, :project_id => @project, :id => 1
    assert_response 403
    put :update, :project_id => @project, :id => 1, :material => {:inner_code => '001', :name => 'test_material'}
    assert_response 403
    delete :destroy, :project_id => @project, :id => 1
    assert_response 403
    get :new, :project_id => @project
    assert_response 403
    post :create, :project_id => @project, :material => {:inner_code => '001', :name => 'test_material'}
    assert_response 403
  end
  
  test "user permition" do
    User.current = User.find(2)
    @request.session[:user_id] = 2
    get :show, :project_id => @project, :id => 1
    assert_response 403
    get :edit, :project_id => @project, :id => 1
    assert_response 403
    put :update, :project_id => @project, :id => 1, :material => {:inner_code => '001', :name => 'test_material'}
    assert_response 403
    delete :destroy, :project_id => @project, :id => 1
    assert_response 403
    get :new, :project_id => @project
    assert_response 403
    post :create, :project_id => @project, :material => {:inner_code => '001', :name => 'test_material'}
    assert_response 403
  end

  test "show" do
    get :show, :project_id => @project, :id => 1
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:material)
    assert_not_nil assigns(:project)
  end
  
  test "edit" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    @material = Material.find(3)
    get :edit, :project_id => 3, :id => 3
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:material)
  end
  
  test "update" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    put :update, :project_id => @project, :id => 3, :material => {:inner_code => '003', :name => 'test_material_changed'}
    assert_response :redirect
    assert_equal "test_material_changed", Material.find(3).name
  end
  
  test "destroy" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    assert_difference 'Material.count', -1 do
      delete :destroy, :project_id => 3, :id => 3
    end
    assert_redirected_to :action => 'index', :project_id => @project
  end
  
  test "new" do
    get :new, :project_id => @project
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:material)
    assert_not_nil assigns(:project)
  end
  
  test "create" do
    delete :destroy, :project_id => @project, :id => 1
    post :create, :project_id => @project, :material => {:inner_code => '005', :name => 'test_material5'}
    assert_equal "test_material5", Material.last.name
  end

  
end
