module WarehousesHelper
  
  # define the status' enum list
  def collection_for_status_select
    [[l(:label_warehouse_status_normal), Material::STATUS_NORMAL],
     [l(:label_material_status_lock), Material::STATUS_LOCK]]
  end

  # define the type' enum list
  def collection_for_type_select
    [[l(:label_warehouse_type_inner), Warehouse::TYPE_INNER],
     [l(:label_warehouse_type_virtual), Warehouse::TYPE_VIRTUAL],
     [l(:label_warehouse_type_outer), Warehouse::TYPE_OUTER],
     [l(:label_warehouse_type_rent), Warehouse::TYPE_RENT],
     [l(:label_warehouse_type_other), Warehouse::TYPE_OTHER]]
  end
end
