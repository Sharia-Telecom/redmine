class Material < ActiveRecord::Base
  include Redmine::SafeAttributes  
  
  belongs_to :project
  belongs_to :user
  belongs_to :handover, :class_name => 'User', :foreign_key => 'handover_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :responsible_by, :class_name => 'User', :foreign_key => 'responsible_by_id'
  belongs_to :purchaser, :class_name => 'User', :foreign_key => 'purchaser_id'
  belongs_to :category, :class_name => 'MaterialCategory', :foreign_key => "category_id"
  has_many :sub_materials, :class_name => 'Material', :foreign_key => "parent_material_id", :dependent => :destroy 
  belongs_to :parent_material, :class_name => 'Material' 
  has_many :comments, :as => :commented, :dependent => :delete_all
  has_many :material_cycles, :dependent => :destroy 
  
  validates_presence_of :inner_code, :name, :project
  validates_length_of :inner_code, maximum: 128
  validates_length_of :name, maximum: 128
  validates_numericality_of :amount, :greater_than => 0, :allow_blank => true
  validates_numericality_of :current_value, :greater_than => 0, :allow_blank => true
  validates_numericality_of :original_value, :greater_than => 0, :allow_blank => true
  
  validate :validate_material
  
  acts_as_attachable
  
  safe_attributes 'project_id',
                  'name',
                  'inner_code',
                  'brand',
                  'device_no',
                  'category_id',
                  'parent_material_id',
                  'amount',
                  'original_value',
                  'current_value',
                  'use_since',
                  'user_id',
                  'handover_id',
                  'author_id',
                  'owner_id',
                  'responsible_by_id',
                  'purchaser_id',
                  'purchase_at',
                  'use_since',
                  'handover_at',
                  'location',
                  'location_since',
                  'detail',
                  'property',
                  'status',
                  'remark'
  
  STATUS_NORMAL = '0'
  STATUS_USELESS = '5'
  STATUS_LOCK = '6'
  STATUS_OTHER = '9'
 
  PROPERTY_INNER = '0'
  PROPERTY_OUTSIDE = '1'
  PROPERTY_PERSONAL = '2'
  PROPERTY_OTHER = '9'
  
  def status_name
    case self.status
    when STATUS_NORMAL
      l(:label_material_status_normal)
    when STATUS_USELESS
      l(:label_material_status_useless)
    when STATUS_LOCK
      l(:label_material_status_lock)
    when STATUS_OTHER
      l(:label_material_status_other)
    else
      ""
    end
  end
  
  def property_name
    case self.property
    when PROPERTY_INNER
      l(:label_material_property_inner)
    when PROPERTY_OUTSIDE
      l(:label_material_property_outside)
    when PROPERTY_PERSONAL
      l(:label_material_property_personal)
    when PROPERTY_OTHER
      l(:label_material_property_other)
    else
      ""
    end
  end
  
  scope :visible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :show_materials, *args))
  }
  
  scope :by_project, lambda {|project_id| where(:project_id => project_id) unless project_id.blank? }
  scope :live_search, lambda {|search| where("(#{Material.table_name}.name LIKE ?)", "%#{search}%")}

  acts_as_event :datetime => :updated_at,
                :url => Proc.new {|o| {:controller => 'materials', :action => 'show', :project_id => o.project_id, :id => o}},
                :title => Proc.new {|o| "#{l(:label_materials)} ##{o.id} #{o.name}" },
                :description => Proc.new {|o| o.detail.to_s }

  if ActiveRecord::VERSION::MAJOR >= 4
    acts_as_activity_provider :type => 'materials',
                              :permission => :show_materials,
                              :timestamp => "#{table_name}.updated_at",
                              :author_key => :author_id,
                              :scope => joins(:project)
  else
    acts_as_activity_provider :type => 'materials',
                              :permission => :show_materials,
                              :timestamp => "#{table_name}.updated_at",
                              :author_key => :author_id,
                              :find_options => {:include => :project}
  end
  
  if ActiveRecord::VERSION::MAJOR >= 4
    acts_as_searchable :columns => ["#{table_name}.name", "#{table_name}.detail"],
                       :scope => includes(:project),
                       :project_key => "#{Project.table_name}.id",
                       :permission => :show_materials,
                       :date_column => "updated_at"
  else
    acts_as_searchable :columns => ["#{table_name}.name", "#{table_name}.detail"],
                       :include => :project,
                       :date_column => "#{table_name}.updated_at",
                       :include => [:project],
                       :project_key => "#{Project.table_name}.id",
                       :permission => :show_materials,
                       :date_column => "updated_at"
  end
  
  # Returns a SQL conditions string used to find all time entries visible by the specified user
  def self.visible_condition(user, options={})
  end

  def creatable_by?(usr = nil, project)
    prj ||= @project || self.project
    (usr || User.current).allowed_to?(:new_materials, prj)
  end
  
  def visible?(usr = nil)
    (usr || User.current).allowed_to?(:show_materials, self.project)
  end

  def editable_by?(usr, prj=nil)
    prj ||= @project || self.project
    usr && (usr.allowed_to?(:edit_materials, prj))
  end

  def destroyable_by?(usr, prj=nil)
    prj ||= @project || self.project
    (usr || User.current).allowed_to?(:delete_materials, prj)
  end

  def commentable?(user=User.current)
    user.allowed_to?(:comment_materials, project)
  end
  
  def can_cycle_entry?
    # cycles are empty or last cycle's type is exit
    self.material_cycles.empty? || self.material_cycles.last.stage == MaterialCycle::STAGE_EXIT
  end
  
  def can_cycle_middle?
    !self.material_cycles.empty? && self.material_cycles.last.stage != MaterialCycle::STAGE_EXIT
  end
  
  def can_cycle_exit?
    # same as middle
    !self.material_cycles.empty? && self.material_cycles.last.stage != MaterialCycle::STAGE_EXIT
  end
  
  def validate_material
    # Checks parent material assignment,only two level
    # first level
    if self == self.parent_material
      errors.add :parent_material_id, :invalid
    end

    if !self.parent_material.nil? && self == self.parent_material.parent_material
      errors.add :parent_material_id, :invalid
    end
    # second level
  end

  def purchase_at
    zone = User.current.time_zone
    return "" if super.nil?
    zone ? super.in_time_zone(zone) : (super.utc? ? super.localtime : super)
  end
  
  def purchase_at_time
    purchase_at.present? ? purchase_at.to_s(:time) : ""
  end

  def use_since
    zone = User.current.time_zone
    return "" if super.nil?
    zone ? super.in_time_zone(zone) : (super.utc? ? super.localtime : super)
  end
  
  def use_since_time
    use_since.present? ? use_since.to_s(:time) : ""
  end
  
  def handover_at
    zone = User.current.time_zone
    return "" if super.nil?
    zone ? super.in_time_zone(zone) : (super.utc? ? super.localtime : super)
  end
  
  def handover_at_time
    handover_at.present? ? handover_at.to_s(:time) : ""
  end
  
  def location_since
    zone = User.current.time_zone
    return "" if super.nil?
    zone ? super.in_time_zone(zone) : (super.utc? ? super.localtime : super)
  end
  
  def location_since_time
    location_since.present? ? location_since.to_s(:time) : ""
  end

  
  acts_as_attachable :view_permission => :show_materials

  def local_time_zone
    zone = User.current.time_zone
    return "" if super.nil?
    zone ? super.in_time_zone(zone) : (super.utc? ? super.localtime : super)
  end
end
