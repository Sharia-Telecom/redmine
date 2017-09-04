class MaterialCycle < ActiveRecord::Base
  attr_accessible :material_id, :stage, :event_type, :location, :outsider, :direction, :order_no, :value, :purpose, :warehouse_id, :issue_id
 
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :material
  belongs_to :project

  belongs_to :warehouse
  belongs_to :issue

  validates_presence_of :stage, :event_type, :project, :material
  validates_numericality_of :value, :greater_than => 0, :allow_blank => true
  
  before_save :set_direction
  
  STAGE_ENTRY = '0'
  STAGE_MIDDLE = '1'
  STAGE_EXIT = '9'
  
  TYPE_BUY_IN = '000'
  TYPE_SELL_OUT = '100'
  TYPE_RENT = '001'
  TYPE_RENT_OUT = '101'
  TYPE_BORROW = '002'
  TYPE_LOAN = '102'
  TYPE_STOCK_IN = '003'
  TYPE_STOCK_OUT = '103'
  TYPE_GET = '004'
  TYPE_GIVE = '104'
  TYPE_SCRAP = '105'
  TYPE_LOSS = '106'
  TYPE_TRANSFER = '107'
  TYPE_RETURN = '108'
  TYPE_DISCARD = '109'
  TYPE_LOCK = '110'
  TYPE_UNKNOWN = '999'
  
  PURPOSE_USAGE = '0'
  PURPOSE_STORE = '1'
  PURPOSE_MAINTAIN = '2'
  PURPOSE_REPAIR = '3'
  PURPOSE_UNKNOWN = '9'
  
  DIRECTION_FROM = '0'
  DIRECTION_TO = '1'
  DIRECTION_UNDEF = '9'

  if ActiveRecord::VERSION::MAJOR >= 4
    acts_as_activity_provider :type => 'material_cycles',
                              :permission => :show_material_cycles,
                              :timestamp => "#{table_name}.created_at",
                              :author_key => :author_id,
                              :scope => joins(:project)
  else
    acts_as_activity_provider :type => 'material_cycles',
                              :permission => :show_material_cycles,
                              :timestamp => "#{table_name}.created_at",
                              :author_key => :author_id,
                              :find_options => {:include => :project}
  end
  
  # if ActiveRecord::VERSION::MAJOR >= 4
    # acts_as_searchable :columns => ["#{table_name}.order_no", "#{table_name}.location", "#{table_name}.outsider"],
                       # :scope => includes(:project),
                       # :project_key => "#{Project.table_name}.id",
                       # :permission => :show_material_cycles,
                       # :date_column => "created_at"
  # else
    # acts_as_searchable :columns => ["#{table_name}.order_no", "#{table_name}.location", "#{table_name}.outsider"],
                       # :include => :project,
                       # :date_column => "#{table_name}.created_at",
                       # :include => [:project],
                       # :project_key => "#{Project.table_name}.id",
                       # :permission => :show_material_cycles,
                       # :date_column => "created_at"
  # end
#   

  scope :visible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :show_material_cycles, *args))
  }
  
  scope :by_project, lambda {|project_id| where(:project_id => project_id) unless project_id.blank? }

  # scope :live_search, lambda {|search| where("(#{MaterialCycle.table_name}.name LIKE ?)", "%#{search}%")}

  acts_as_event :datetime => :created_at,
                :url => Proc.new {|o| {:controller => 'material_cycles', :action => 'show', :project_id => o.project_id, :material_id => o.material_id, :id => o}},
                :title => Proc.new {|o| "#{l(:label_material_cycles)} ##{o.id}" },
                :description => Proc.new {|o| "#{o.material.name} #{o.stage_name}" } 


  scope :on_material, lambda {|material|
    joins(:material).
    where("#{Material.table_name}.id = #{material.id}")
  }

  def stage_name
    case self.stage
    when STAGE_ENTRY
      l(:label_material_cycle_stage_entry)
    when STAGE_MIDDLE
      l(:label_material_cycle_stage_middle)
    when STAGE_EXIT
      l(:label_material_cycle_stage_exit)
    else
      ''
    end
  end

  def type_name
    case self.event_type
    when TYPE_BUY_IN
      l(:label_material_cycle_event_type_buy_in)
    when TYPE_SELL_OUT
      l(:label_material_cycle_event_type_sell_out)
    when TYPE_RENT
      l(:label_material_cycle_event_type_rent)
    when TYPE_RENT_OUT
      l(:label_material_cycle_event_type_rent_out)
    when TYPE_BORROW
      l(:label_material_cycle_event_type_borrow)
    when TYPE_LOAN
      l(:label_material_cycle_event_type_loan)
    when TYPE_STOCK_IN
      l(:label_material_cycle_event_type_stock_in)
    when TYPE_STOCK_OUT
      l(:label_material_cycle_event_type_stock_out)
    when TYPE_GET
      l(:label_material_cycle_event_type_get)
    when TYPE_GIVE
      l(:label_material_cycle_event_type_give)
    when TYPE_SCRAP
      l(:label_material_cycle_event_type_scrap)
    when TYPE_LOSS
      l(:label_material_cycle_event_type_loss)
    when TYPE_RETURN
      l(:label_material_cycle_event_type_return)
    when TYPE_TRANSFER
      l(:label_material_cycle_event_type_transfer)
    when TYPE_DISCARD
      l(:label_material_cycle_event_type_discard)
    when TYPE_LOCK
      l(:label_material_cycle_event_type_lock)
    when TYPE_UNKNOWN
      l(:label_material_cycle_event_type_unknown)
    else
      ''
    end
  end
  
  def purpose_name
    case self.purpose
    when PURPOSE_USAGE
      l(:label_material_cycle_purpose_usage)
    when PURPOSE_STORE
      l(:label_material_cycle_purpose_store)
    when PURPOSE_MAINTAIN
      l(:label_material_cycle_purpose_maintain)
    when PURPOSE_REPAIR
      l(:label_material_cycle_purpose_repair)
    when PURPOSE_UNKNOWN
      l(:label_material_cycle_purpose_unknown)
    else
      ''
    end
  end

  def direction_name
    case self.direction
    when DIRECTION_FROM
      l(:label_material_cycle_direction_from)
    when DIRECTION_TO
      l(:label_material_cycle_direction_to)
    when DIRECTION_UNDEF
      l(:label_material_cycle_direction_undef)
    end
  end

  # Returns a SQL conditions string used to find all time entries visible by the specified user
  def self.visible_condition(user, options={})
  end

  def creatable_by?(usr = nil, project)
    prj ||= @project || self.project
    (usr || User.current).allowed_to?(:new_material_cycles, prj)
  end
  
  def visible?(usr = nil)
    (usr || User.current).allowed_to?(:show_material_cycles, self.project)
  end

  def editable_by?(usr, prj=nil)
    prj ||= @project || self.project
    usr && (usr.allowed_to?(:edit_material_cycles, prj))
  end

  def destroyable_by?(usr, prj=nil)
    prj ||= @project || self.project
    (usr || User.current).allowed_to?(:delete_material_cycles, prj)
  end
  
  def material_name
    self.material.name
  end
  
  def set_direction
    # set direction according event_type
    self.direction = self.event_type[0]
  end
end
