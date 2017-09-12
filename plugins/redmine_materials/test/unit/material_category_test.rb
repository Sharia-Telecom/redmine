require File.expand_path('../../test_helper', __FILE__)

class MaterialCategoriesTest < ActiveSupport::TestCase

  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/',
                                          :material_categories)

  def setup
    @material_category = MaterialCategory.find(1)    
  end
  
  test "blank valid" do
    assert @material_category.valid?, "should be valid"
    @material_category.name = nil
    assert_not @material_category.valid?, "name should be present"
  end
  
  test "unique valid" do
    assert @material_category.valid?, "should be valid"
    material_category_dup = @material_category.dup
    assert_not material_category_dup.valid?, "name should be unique"
  end
end
