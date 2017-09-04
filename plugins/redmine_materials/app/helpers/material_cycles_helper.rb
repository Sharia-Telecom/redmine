module MaterialCyclesHelper
  # define the status' enum list
  def collection_for_stage_select
    [[l(:label_material_cycle_stage_entry), MaterialCycle::STAGE_ENTRY],
     [l(:label_material_cycle_stage_middle), MaterialCycle::STAGE_MIDDLE],
     [l(:label_material_cycle_stage_exit), MaterialCycle::STAGE_EXIT]]
  end
  
  # define the type's enum list
  def collection_for_type_select(stage=nil)
    case stage
    when nil
      [[l(:label_material_cycle_event_type_buy_in), MaterialCycle::TYPE_BUY_IN],
       [l(:label_material_cycle_event_type_sell_out), MaterialCycle::TYPE_SELL_OUT],
       [l(:label_material_cycle_event_type_rent), MaterialCycle::TYPE_RENT],
       [l(:label_material_cycle_event_type_rent_out), MaterialCycle::TYPE_RENT_OUT],
       [l(:label_material_cycle_event_type_borrow), MaterialCycle::TYPE_BORROW],
       [l(:label_material_cycle_event_type_loan), MaterialCycle::TYPE_LOAN],
       [l(:label_material_cycle_event_type_stock_in), MaterialCycle::TYPE_STOCK_IN],
       [l(:label_material_cycle_event_type_stock_out), MaterialCycle::TYPE_STOCK_OUT],
       [l(:label_material_cycle_event_type_get), MaterialCycle::TYPE_GET],
       [l(:label_material_cycle_event_type_give), MaterialCycle::TYPE_GIVE],
       [l(:label_material_cycle_event_type_scrap), MaterialCycle::TYPE_SCRAP],
       [l(:label_material_cycle_event_type_return), MaterialCycle::TYPE_RETURN],
       [l(:label_material_cycle_event_type_discard), MaterialCycle::TYPE_DISCARD],
       [l(:label_material_cycle_event_type_loss), MaterialCycle::TYPE_LOSS],
       [l(:label_material_cycle_event_type_lock), MaterialCycle::TYPE_LOCK],
       [l(:label_material_cycle_event_type_unknown), MaterialCycle::TYPE_UNKNOWN]]

    when MaterialCycle::STAGE_ENTRY
      [[l(:label_material_cycle_event_type_buy_in), MaterialCycle::TYPE_BUY_IN],
       [l(:label_material_cycle_event_type_rent), MaterialCycle::TYPE_RENT],
       [l(:label_material_cycle_event_type_borrow), MaterialCycle::TYPE_BORROW],
       [l(:label_material_cycle_event_type_get), MaterialCycle::TYPE_GET]]
    when MaterialCycle::STAGE_MIDDLE
      [[l(:label_material_cycle_event_type_rent), MaterialCycle::TYPE_RENT],
       [l(:label_material_cycle_event_type_rent_out), MaterialCycle::TYPE_RENT_OUT],
       [l(:label_material_cycle_event_type_borrow), MaterialCycle::TYPE_BORROW],
       [l(:label_material_cycle_event_type_loan), MaterialCycle::TYPE_LOAN],
       [l(:label_material_cycle_event_type_stock_in), MaterialCycle::TYPE_STOCK_IN],
       [l(:label_material_cycle_event_type_stock_out), MaterialCycle::TYPE_STOCK_OUT],
       [l(:label_material_cycle_event_type_get), MaterialCycle::TYPE_GET],
       [l(:label_material_cycle_event_type_give), MaterialCycle::TYPE_GIVE]]
    when MaterialCycle::STAGE_EXIT
      [[l(:label_material_cycle_event_type_scrap), MaterialCycle::TYPE_SCRAP],
       [l(:label_material_cycle_event_type_return), MaterialCycle::TYPE_RETURN],
       [l(:label_material_cycle_event_type_discard), MaterialCycle::TYPE_DISCARD],
       [l(:label_material_cycle_event_type_loss), MaterialCycle::TYPE_LOSS],
       [l(:label_material_cycle_event_type_lock), MaterialCycle::TYPE_LOCK]]
   end
  end
 
  # define the direction's enum list
  def collection_for_direction_select
    [[l(:label_material_cycle_direction_from), MaterialCycle::DIRECTION_FROM],
     [l(:label_material_cycle_direction_to), MaterialCycle::DIRECTION_TO]]
  end

  # define the purpose's enum list
  def collection_for_purpose_select
    [[l(:label_material_cycle_purpose_usage), MaterialCycle::PURPOSE_USAGE],
     [l(:label_material_cycle_purpose_store), MaterialCycle::PURPOSE_STORE],
     [l(:label_material_cycle_purpose_maintain), MaterialCycle::PURPOSE_MAINTAIN],
     [l(:label_material_cycle_purpose_repair), MaterialCycle::PURPOSE_REPAIR],
     [l(:label_material_cycle_purpose_unknown), MaterialCycle::PURPOSE_UNKNOWN]]
  end
  
  def warehouses_for_select
    Warehouse.all.map{|a| [a.name, a.id.to_s]}
  end
  
  def issue_subject_pre
        case stage
    when nil
      l(:label_material_cycle_nil_issue_subject)
    when MaterialCycle::STAGE_ENTRY
      l(:label_material_cycle_entry_issue_subject)
    when MaterialCycle::STAGE_MIDDLE
       l(:label_material_cycle_middle_issue_subject)
    when MaterialCycle::STAGE_EXIT
       l(:label_material_cycle_exit_issue_subject)
   end
  end
end
