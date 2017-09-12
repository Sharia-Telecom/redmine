require File.expand_path('../../test_helper', __FILE__)

class MaterialCyclesControllerTest < ActionController::TestCase
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
                                          [:materials, :material_cycles])

  def setup
    @project = Project.find(1)
    @project.enable_module!(:redmine_materials)
    User.current = User.find(1)
    @request.session[:user_id] = 1
    @material = Material.find(1)
  end
  
   test "module permition" do
    @project.disable_module!(:redmine_materials)
    get :show, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    get :edit, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    put :update, :project_id => @project, :material_id => @material, :id => 1, :material_cycle => {:stage => '0', :event_type => '002'}
    assert_response 403
    delete :destroy, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    get :new, :project_id => @project, :material_id => @material
    assert_response 403
    post :create, :project_id => @project, :material_id => @material, :material_cycle  => {:stage => '0', :event_type => '002'}
    assert_response 403
  end
  
  test "user permition" do
    User.current = User.find(2)
    @request.session[:user_id] = 2
    get :show, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    get :edit, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    put :update, :project_id => @project, :material_id => @material, :id => 1, :material_cycle => {:stage => '0', :event_type => '002'}
    assert_response 403
    delete :destroy, :project_id => @project, :material_id => @material, :id => 1
    assert_response 403
    get :new, :project_id => @project, :material_id => @material
    assert_response 403
    post :create, :project_id => @project, :material_id => @material, :material_cycle  => {:stage => '0', :event_type => '002'}

  end

  test "show" do
    get :show, :project_id => @project, :material_id => @material, :id => 1
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:material_cycle)
    assert_not_nil assigns(:material)
    assert_not_nil assigns(:project)
  end
  
  test "edit" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    @material = Material.find(3)
    @material_cycle = MaterialCycle.find(4)
    get :edit, :project_id => @project, :material_id => @material, :id => @material_cycle
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:material_cycle)
  end
  
  test "update" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    @material = Material.find(3)
    @material_cycle = MaterialCycle.find(4)
    put :update, :project_id => @project, :material_id => @material, :id => @material_cycle, :material_cycle => {:stage => '9', :event_type => '001', :order_no => "123456"}
    assert_response :redirect
    order_no = MaterialCycle.find(4).order_no
    assert_equal "123456", order_no, "order_no is #{order_no}"
  end
  
  test "destroy" do
    @project = Project.find(3)
    @project.enable_module!(:redmine_materials)
    @material = Material.find(3)
    @material_cycle = MaterialCycle.find(4)
    assert_difference 'MaterialCycle.count', -1 do
      delete :destroy, :project_id => @project, :material_id => @material, :id => @material_cycle
    end
    assert_redirected_to :action => 'index', :project_id => @project, :material_id => @material
  end
  
  test "new" do
    get :new, :project_id => @project, :material_id => @material
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:material_cycle)
    assert_not_nil assigns(:material)
    assert_not_nil assigns(:project)
  end
  
  # test "create" do
    # delete :destroy, :project_id => @project, :material_id => @material, :id => @material_cycle
    # post :create, :stage => MaterialCycle::STAGE_MIDDLE, :project_id => @project, :material_id => @material, :material_cycle => {:event_type => '001', :order_no => "654321"}
    # assert_equal "654321", MaterialCycle.last.order_no, "order_no is #{MaterialCycle.last.id}"
  # end

  
end
