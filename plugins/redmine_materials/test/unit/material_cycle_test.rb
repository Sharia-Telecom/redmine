require File.expand_path('../../test_helper', __FILE__)

class MaterialCycleTest < ActiveSupport::TestCase

  fixtures :projects
  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/',
                                          [:materials, :material_cycles])

  def setup
    @material_cycle = MaterialCycle.find(1)    
  end
  
  test "blank valid" do
    assert @material_cycle.valid?, "should be valid"
    @material_cycle.stage = nil
    assert_not @material_cycle.valid?, "stage should be present"
    
    # event_type is reserved
    @material_cycle.assign_attributes :event_type => "   "
    assert @material_cycle.invalid?, "event_type should be present"
  end
  
  test "number valid" do
    assert @material_cycle.valid?, "should be valid"
    @material_cycle.value = "abcd12ds234"
    assert_not @material_cycle.valid?, "current_value be number"
  end
  
  test "should belongs to project and material" do
    assert @material_cycle.valid?, "should be valid"
    @material_cycle.project = nil
    assert_not @material_cycle.valid?, "should belongs to one project"    
    @material_cycle.reload
    assert @material_cycle.valid?, "should be valid"
    @material_cycle.material = nil
    assert_not @material_cycle.valid?, "should belongs to one material"
  end
end
