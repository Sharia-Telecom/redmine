class Warehouse < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  
  attr_accessible :name, :code, :type, :location, :responsible_by_id, :found_date, :status, :description
 
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :responsible_by, :class_name => 'User', :foreign_key => 'responsible_by_id'
  
  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code
  
  validates_length_of :code, maximum: 36
  validates_length_of :name, maximum: 64
  
  
  STATUS_NORMAL = '0'
  STATUS_LOCK = '6'
  
  TYPE_INNER = '0'
  TYPE_VIRTUAL = '1'
  TYPE_OUTER = '2'
  TYPE_RENT = '3'
  TYPE_TEMP = '4'
  TYPE_OTHER = '9'

  def status_name
    case self.status
    when STATUS_NORMAL
      l(:label_warehouse_status_normal)
    when STATUS_LOCK
      l(:label_warehouse_status_lock)
    else
      # return origin value
      self.status
    end
  end

  def type_name
    case self.type
    when TYPE_INNER
      l(:label_warehouse_type_inner)
    when TYPE_VIRTUAL
      l(:label_warehouse_type_virtual)
    when TYPE_OUTER
      l(:label_warehouse_type_outer)
    when TYPE_RENT
      l(:label_warehouse_type_rent)
    when TYPE_TEMP
      l(:label_warehouse_type_temp)      
    when TYPE_OTHER
      l(:label_warehouse_type_other)
    else
      # return origin value
      self.type
    end
  end
end
