require File.expand_path('../../test_helper', __FILE__)

class MaterialTest < ActiveSupport::TestCase
  fixtures :projects
  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/',
                                          :materials)

  def setup
    @material = Material.find(1)    
  end
  
  test "blank valid" do
    assert @material.valid?, "should be valid"
    @material.inner_code = nil
    assert_not @material.valid?, "inner_code should not be nil"
    @material.reload
    assert @material.valid?, "should be valid"
    @material.name = ''
    assert_not @material.valid?, "name should not be empty"
  end
  
  test "length valid" do
    assert @material.valid?, "should be valid"
    @material.inner_code = 'code' * 50
    assert_not @material.valid?, "inner_code's length should be lower than 128, actually it's #{@material.inner_code.length}"
    @material.reload
    assert @material.valid?, "should be valid"
    @material.name = 'name' * 50
    assert_not @material.valid?, "name's length should be lower than 128, actually it's #{@material.name.length}"
  end
  
  test "number valid" do
    assert @material.valid?, "should be valid"
    @material.amount = "111abcd"
    assert_not @material.valid?, "amount should be number"
    @material.reload
    assert @material.valid?, "should be valid"
    @material.original_value = "222abcd"
    assert_not @material.valid?, "original_value should be number"
    @material.reload
    assert @material.valid?, "should be valid"
    @material.current_value = "abcd333"
    assert_not @material.valid?, "current_value be number"
  end
  
  test "should belongs to project" do
    assert @material.valid?, "should be valid"
    @material.project = nil
    assert_not @material.valid?, "should belongs to one project"    
  end
  
  test "parent should not be nested" do
    assert @material.valid?, "should be valid"
    @material.parent_material = @material
    assert_not @material.valid?, "parent and self are same"
    # sec level
    @material.reload
    assert @material.valid?, "should be valid"
    material2 = Material.find(2)
    material2.parent_material = @material
    @material.parent_material = material2
    assert_not @material.valid?, "parent and self are same"
  end
end
