class MaterialCycleQuery < Query
  include MaterialCyclesHelper
  
  self.queried_class = MaterialCycle

  self.available_columns = [
    QueryColumn.new(:project, :sortable => "#{Project.table_name}.name", :groupable => true),
    QueryColumn.new(:material_name, :sortable => "#{Material.table_name}.name", :groupable => true),
    QueryColumn.new(:issue, :sortable => "#{Issue.table_name}.id"),
    QueryColumn.new(:stage_name, :sortable => "#{MaterialCycle.table_name}.stage", :default_order => 'desc'),
    QueryColumn.new(:type_name, :sortable => "#{MaterialCycle.table_name}.event_type", :default_order => 'desc'),
    QueryColumn.new(:order_no, :sortable => "#{MaterialCycle.table_name}.order_no", :default_order => 'desc'),
    QueryColumn.new(:direction_name, :sortable => "#{MaterialCycle.table_name}.direction", :default_order => 'desc'),
    QueryColumn.new(:location, :sortable => "#{MaterialCycle.table_name}.location", :default_order => 'desc'),
    QueryColumn.new(:warehouse, :sortable => "#{Warehouse.table_name}.name", :groupable => true, :caption => :label_warehouse),
    QueryColumn.new(:value, :sortable => "#{MaterialCycle.table_name}.value", :default_order => 'desc'),
    QueryColumn.new(:outsider, :sortable => "#{MaterialCycle.table_name}.outsider", :default_order => 'desc'),
    QueryColumn.new(:purpose_name, :sortable => "#{MaterialCycle.table_name}.purpose", :default_order => 'desc'),
    QueryColumn.new(:author, :sortable => "#{MaterialCycle.table_name}.author_id", :default_order => 'desc'),
    QueryColumn.new(:created_at, :sortable => "#{MaterialCycle.table_name}.created_at", :caption => :field_created_on),
    QueryColumn.new(:updated_at, :sortable => "#{MaterialCycle.table_name}.updated_at", :caption => :field_updated_on)
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= {}
  end

  def initialize_available_filters
    add_available_filter "value", :type => :float, :label => :field_value
    add_available_filter "location", :type => :text
    add_available_filter "order_no", :type => :text
    add_available_filter "outsider", :type => :text
    add_available_filter "purpose", :type => :text

    add_available_filter "updated_at", :type => :date_past, :label => :field_updated_on
    add_available_filter "created_at", :type => :date, :label => :field_created_on

    principals = []
    if project
      principals += project.principals.visible.sort
      unless project.leaf?
        subprojects = project.descendants.visible.to_a
        if subprojects.any?
          add_available_filter "subproject_id",
            :type => :list_subprojects,
            :values => subprojects.collect{|s| [s.name, s.id.to_s] }
          principals += Principal.member_of(subprojects).visible
        end
      end
    else
      if all_projects.any?
        # members of visible projects
        principals += Principal.member_of(all_projects).visible
        # project filter
        project_values = []
        if User.current.logged? && User.current.memberships.any?
          project_values << ["<< #{l(:label_my_projects).downcase} >>", "mine"]
        end
        project_values += all_projects_values
        add_available_filter("project_id",
          :type => :list, :values => project_values
        ) unless project_values.empty?
      end
    end
    principals.uniq!
    principals.sort!

    initialize_project_filter
    initialize_author_filter
    
    add_available_filter "stage", :type => :list, :values => [[l(:label_material_cycle_stage_entry), MaterialCycle::STAGE_ENTRY],
                                                                        [l(:label_material_cycle_stage_middle), MaterialCycle::STAGE_MIDDLE],
                                                                        [l(:label_material_cycle_stage_exit), MaterialCycle::STAGE_EXIT]] , :label => :field_stage
    add_available_filter "event_type", :type => :list, :values => collection_for_type_select, :label => :field_event_type
    add_available_filter "purpose", :type => :list, :values => [[l(:label_material_cycle_purpose_usage), MaterialCycle::PURPOSE_USAGE],
                                                                        [l(:label_material_cycle_purpose_store), MaterialCycle::PURPOSE_STORE],
                                                                        [l(:label_material_cycle_purpose_unknown), MaterialCycle::PURPOSE_UNKNOWN]] , :label => :field_purpose

    add_available_filter "stage", :type => :list, :values => [[l(:label_material_cycle_direction_from), MaterialCycle::DIRECTION_FROM],
                                                                        [l(:label_material_cycle_direction_to), MaterialCycle::DIRECTION_TO]] , :label => :field_direction
    add_available_filter("warehouse_id",
      :type => :list, :values => warehouses_for_select, :label => :label_warehouse
    )                                                                        
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
  end

  def default_columns_names
    @default_columns_names ||= [:project, :issue, :material_name, :stage_name, :type_name, :outsider, :location_name, :author]
  end

  def results_scope(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)
    MaterialCycle.visible.joins(:project).
      where(statement).
      order(order_option)
  end

  # Accepts :from/:to params as shortcut filters
  def build_from_params(params)
    super
    self
  end
  
  def initialize_project_filter(position=nil)
    if project.blank?
      project_values = []
      if User.current.logged? && User.current.memberships.any?
        project_values << ["<< #{l(:label_my_projects).downcase} >>", "mine"]
      end
      project_values += all_projects_values
      add_available_filter("project_id", :order => position,
        :type => :list, :values => project_values
      ) unless project_values.empty?
    end
  end

  def initialize_author_filter(position=nil)
    add_available_filter("author_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
  def users_values
    return @users_values if @users_values
    users = principals.select {|p| p.is_a?(User)}
    @users_values = []
    @users_values << ["<< #{l(:label_me)} >>", "me"] if User.current.logged?
    @users_values += users.collect{|s| [s.name, s.id.to_s] }
    @users_values
  end
  
  def principals
    return @principals if @principals
    @principals = []
    if project
      @principals += project.principals.sort
      unless project.leaf?
        subprojects = project.descendants.visible.all
        @principals += Principal.member_of(subprojects)
      end
    else
      if all_projects.any?
        @principals += Principal.member_of(all_projects)
      end
    end
    @principals.uniq!
    @principals.sort!
  end
  
  def initialize_user_filter(position=nil)
    add_available_filter("user_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
end
