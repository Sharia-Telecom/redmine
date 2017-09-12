require File.expand_path('../../test_helper', __FILE__)

class WarehouseTest < ActiveSupport::TestCase

  RedmineMaterials::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_materials).directory + '/test/fixtures/',
                                          :warehouses)

  def setup
    @warehouse = Warehouse.find(1)    
  end
  
  test "blank valid" do
    assert @warehouse.valid?, "should be valid"
    @warehouse.code = nil
    assert_not @warehouse.valid?, "code should be present"
    @warehouse.reload
    assert @warehouse.valid?, "should be valid"
    @warehouse.name = nil
    assert_not @warehouse.valid?, "name should be present"
  end
  
  test "length valid" do
    assert @warehouse.valid?, "should be valid"
    @warehouse.code = "a"*38
    assert_not @warehouse.valid?, "code's length should be lower than 36, actually it's #{@warehouse.code.length}"
    @warehouse.reload
    assert @warehouse.valid?, "should be valid"
    @warehouse.name = "a"*65
    assert_not @warehouse.valid?, "name's length should be lower than 64, actually it's #{@warehouse.name.length}"
  end
  
  test "unique valid" do
    assert @warehouse.valid?, "should be valid"
    warehouse_dup = @warehouse.dup
    assert_not warehouse_dup.valid?, "name should be unique"
  end
  
end
