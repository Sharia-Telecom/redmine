class MaterialImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include CSVImportable

  attr_accessor :file, :project, :quotes_type

  def klass
    Material
  end

  def build_from_fcsv_row(row)
    ret = Hash[row.to_hash.map{ |k,v| [k.underscore.gsub(' ','_'), force_utf8(v)] }].delete_if{ |k,v| !klass.column_names.include?(k) }
    ret[:use_since] = row['use since'].to_date if row['use since']
    ret[:purchase_at] = row['purchase at'].to_date if row['purchase at']
    ret[:handover_at] = row['handover at'].to_date if row['handover at']
    ret[:location_since] = row['location since'].to_date if row['location since']
    ret[:category_id] = MaterialCategory.where(:name => row['category']).first.try(:id) if row['category']
    ret[:user_id] = User.find_by_login(row['assignee']).try(:id) unless row['assignee'].blank?
    ret[:purchaser_id] = User.find_by_login(row['assignee']).try(:id) unless row['assignee'].blank?
    ret[:handover_id] = User.find_by_login(row['assignee']).try(:id) unless row['assignee'].blank?
    ret[:responsible_by_id] = User.find_by_login(row['assignee']).try(:id) unless row['assignee'].blank?
    ret[:owner_id] = User.find_by_login(row['assignee']).try(:id) unless row['assignee'].blank?
    ret[:author] = User.current
    ret
  end

end
