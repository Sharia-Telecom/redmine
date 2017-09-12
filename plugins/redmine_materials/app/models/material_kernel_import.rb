class MaterialKernelImport < Import

  def klass
    Material
  end

  def saved_objects
    object_ids = saved_items.pluck(:obj_id)
    Material.where(:id => object_ids).order(:id)
  end

  private

  def build_object(row)
    material = Material.new
    material.project = Project.find(settings['project'])
    material.author = user

    attributes = {}
    if inner_code = row_value(row, 'inner_code')
      attributes['inner_code'] = inner_code
    end
    if name = row_value(row, 'name')
      attributes['name'] = name
    end
    if brand = row_value(row, 'brand')
      attributes['brand'] = brand
    end
    if device_no = row_value(row, 'device_no')
      attributes['device_no'] = device_no
    end
    if amount = row_value(row, 'amount')
      attributes['amount'] = amount.to_f
    end
    if original_value = row_value(row, 'original_value')
      attributes['original_value'] = original_value.to_f
    end
    if current_value = row_value(row, 'current_value')
      attributes['current_value'] = current_value.to_f
    end
    if location = row_value(row, 'location')
      attributes['location'] = location
    end
    if remark = row_value(row, 'remark')
      attributes['remark'] = remark
    end
    if detail = row_value(row, 'detail')
      attributes['detail'] = detail
    end
    if status = row_value(row, 'status')
      attributes['status'] = status
    end
    if property = row_value(row, 'property')
      attributes['property'] = property
    end
    if user = row_value(row, 'user')
      attributes['user_id'] = User.where("LOWER(CONCAT(#{User.table_name}.firstname,' ',#{User.table_name}.lastname)) = ? ", user.mb_chars.downcase.to_s)
                                         .first
                                         .try(:id)
    end
    if purchaser = row_value(row, 'purchaser')
      attributes['purchaser_id'] = User.where("LOWER(CONCAT(#{User.table_name}.firstname,' ',#{User.table_name}.lastname)) = ? ", purchaser.mb_chars.downcase.to_s)
                                         .first
                                         .try(:id)
    end
    if handover = row_value(row, 'handover')
      attributes['handover_id'] = User.where("LOWER(CONCAT(#{User.table_name}.firstname,' ',#{User.table_name}.lastname)) = ? ", handover.mb_chars.downcase.to_s)
                                         .first
                                         .try(:id)
    end
    if responsible_by = row_value(row, 'responsible_by')
      attributes['responsible_by_id'] = User.where("LOWER(CONCAT(#{User.table_name}.firstname,' ',#{User.table_name}.lastname)) = ? ", responsible_by.mb_chars.downcase.to_s)
                                         .first
                                         .try(:id)
    end
    if owner = row_value(row, 'owner')
      attributes['owner_id'] = User.where("LOWER(CONCAT(#{User.table_name}.firstname,' ',#{User.table_name}.lastname)) = ? ", owner.mb_chars.downcase.to_s)
                                         .first
                                         .try(:id)
    end
    if category = row_value(row, 'category')
      attributes['category_id'] =  MaterialCategory.where(:name => category).first.try(:id)
    end

    if use_since = row_value(row, 'use_since')
      attributes['use_since'] = use_since
    end
    if purchase_at = row_value(row, 'purchase_at')
      attributes['purchase_at'] = status
    end
    if handover_at = row_value(row, 'handover_at')
      attributes['handover_at'] = handover_at
    end
    if location_since = row_value(row, 'location_since')
      attributes['location_since'] = location_since
    end
    
    material.send :safe_attributes=, attributes, user
    material
  end

end
