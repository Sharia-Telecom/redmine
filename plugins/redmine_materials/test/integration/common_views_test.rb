require File.expand_path('../../test_helper', __FILE__)
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')


class CommonViewsTest < ActiveRecord::VERSION::MAJOR >= 4 ? Redmine::ApiTest::Base : ActionController::IntegrationTest
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/', [:materials,
                                                                                                                    :material_cycles])

  def setup
    RedmineMaterials::TestCase.prepare

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
  end

  test "View materials and cycles activity" do
    log_user("admin", "admin")
    get "/projects/ecookbook/activity?show_materials=1"
    assert_response :success
    get "/projects/ecookbook/activity?show_material_cycles=1"
    assert_response :success
  end

  test "View materials plugin's settings" do
    # log_user("admin", "admin")
    # get "/settings/plugin/redmine_materials"
    # assert_response :success
  end
  
 test "Global search with materials" do
    log_user("admin", "admin")
    get "/search?q=first_mater"
    assert_response :success
  end
  
  test "View issue materials" do
    log_user("admin", "admin")
    EnabledModule.create(:project_id => 1, :name => 'issue_tracking')
    issue = Issue.where(:id => 1).first
    contact = Contact.where(:id => 1).first
    issue.contacts << contact
    issue.save
    get "/issues/1"
    assert_response :success
  end
end
