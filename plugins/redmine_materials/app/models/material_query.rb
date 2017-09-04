class MaterialQuery < Query

  self.queried_class = Material

  self.available_columns = [
    QueryColumn.new(:project, :sortable => "#{Project.table_name}.name", :groupable => true),
    QueryColumn.new(:inner_code, :sortable => "#{Material.table_name}.inner_code", :default_order => 'desc'),
    QueryColumn.new(:name, :sortable => "#{Material.table_name}.name", :default_order => 'desc'),
    QueryColumn.new(:parent_material, :sortable => "#{Material.table_name}.parent_material_id", :default_order => 'desc'),
    QueryColumn.new(:category, :sortable => "#{Material.table_name}.category_id", :default_order => 'desc'),
    QueryColumn.new(:brand, :sortable => "#{Material.table_name}.name", :default_order => 'desc'),
    QueryColumn.new(:amount, :sortable => "#{Material.table_name}.amount", :default_order => 'desc'),
    QueryColumn.new(:original_value, :sortable => "#{Material.table_name}.original_value", :default_order => 'desc'),
    QueryColumn.new(:current_value, :sortable => "#{Material.table_name}.current_value", :default_order => 'desc'),
    QueryColumn.new(:user, :sortable => "#{Material.table_name}.user_id", :default_order => 'desc'),
    QueryColumn.new(:use_since, :sortable => "#{Material.table_name}.use_since", :default_order => 'desc'),
    QueryColumn.new(:purchaser, :sortable => "#{Material.table_name}.purchaser_id", :default_order => 'desc'),
    QueryColumn.new(:purchase_at, :sortable => "#{Material.table_name}.purchase_at", :default_order => 'desc'),
    QueryColumn.new(:location, :sortable => "#{Material.table_name}.location", :default_order => 'desc'),
    QueryColumn.new(:location_since, :sortable => "#{Material.table_name}.location_since", :default_order => 'desc'),
    QueryColumn.new(:handover, :sortable => "#{Material.table_name}.handover_id", :default_order => 'desc'),
    QueryColumn.new(:handover_at, :sortable => "#{Material.table_name}.handover_at", :default_order => 'desc'),
    QueryColumn.new(:owner, :sortable => "#{Material.table_name}.owner_id", :default_order => 'desc'),
    QueryColumn.new(:responsible_by, :sortable => "#{Material.table_name}.responsible_by_id", :default_order => 'desc'),
    QueryColumn.new(:status_name, :sortable => "#{Material.table_name}.status", :default_order => 'desc'),
    QueryColumn.new(:property_name, :sortable => "#{Material.table_name}.property", :default_order => 'desc'),
    QueryColumn.new(:device_no, :sortable => "#{Material.table_name}.device_no", :default_order => 'desc'),
    QueryColumn.new(:remark),
    QueryColumn.new(:detail),
    QueryColumn.new(:author, :sortable => "#{Material.table_name}.author_id", :default_order => 'desc'),
    QueryColumn.new(:created_at, :sortable => "#{Material.table_name}.created_at", :caption => :field_created_on),
    QueryColumn.new(:updated_at, :sortable => "#{Material.table_name}.updated_at", :caption => :field_updated_on)
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= {}
  end

  def initialize_available_filters
    add_available_filter "inner_code", :type => :text
    add_available_filter "name", :type => :text
    add_available_filter "amount", :type => :float, :label => :field_amount
    add_available_filter "original_value", :type => :float, :label => :field_original_value
    add_available_filter "current_value", :type => :float, :label => :field_current_value
    
    add_available_filter "location", :type => :text
    
    add_available_filter "device_no", :type => :text
    
    add_available_filter "use_since", :type => :date, :label => :field_use_since

    add_available_filter "purchase_at", :type => :date, :label => :field_purchase_at
    add_available_filter "handover_at", :type => :date, :label => :field_handover_at
    add_available_filter "location_since", :type => :date, :label => :field_location_since

    add_available_filter "updated_at", :type => :date_past, :label => :field_updated_on
    add_available_filter "created_at", :type => :date, :label => :field_created_on

    material_categories = []
    MaterialCategory.category_tree(MaterialCategory.order(:lft)) do |material_category, level|
      name_prefix = (level > 0 ? '-' * 2 * level + ' ' : '').html_safe #'&nbsp;'
      material_categories << [(name_prefix + material_category.name).html_safe, material_category.id.to_s]
    end
    add_available_filter("category_id", :type => :list, :label => :field_material_category,
      :values => material_categories
    ) if material_categories.any?

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
    users = principals.select {|p| p.is_a?(User)}
    users_values = []
    users_values << ["<< #{l(:label_me)} >>", "me"] if User.current.logged?
    users_values += users.collect{|s| [s.name, s.id.to_s] }
    add_available_filter("user_id",
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
    
    initialize_project_filter
    initialize_author_filter
    initialize_user_filter
    initialize_purchaser_filter
    initialize_responsible_by_filter
    initialize_handover_filter
    initialize_owner_filter
    
    add_available_filter "status", :type => :list, :values => [[l(:label_material_status_normal), Material::STATUS_NORMAL],
                                                                        [l(:label_material_status_useless), Material::STATUS_USELESS],
                                                                        [l(:label_material_status_lock), Material::STATUS_LOCK],
                                                                        [l(:label_material_status_other), Material::STATUS_OTHER]] , :label => :field_status
    add_available_filter "property", :type => :list, :values => [[l(:label_material_property_inner), Material::PROPERTY_INNER],
                                                                        [l(:label_material_property_outside), Material::PROPERTY_OUTSIDE],
                                                                        [l(:label_material_property_personal), Material::PROPERTY_PERSONAL],
                                                                        [l(:label_material_property_other), Material::PROPERTY_OTHER]] , :label => :field_property

    add_available_filter "remark", :type => :text
    add_available_filter "description", :type => :text
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
  end

  def default_columns_names
    @default_columns_names ||= [:project, :inner_code, :name, :category, :user, :responsible_by, :location, :author, :status]
  end

  def results_scope(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)
    
    Material.visible.joins(:project).
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
  
  def initialize_purchaser_filter(position=nil)
    add_available_filter("purchaser_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
  def initialize_handover_filter(position=nil)
    add_available_filter("handover_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
  def initialize_responsible_by_filter(position=nil)
    add_available_filter("responsible_by_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
  def initialize_owner_filter(position=nil)
    add_available_filter("owner_id", :order => position,
      :type => :list_optional, :values => users_values
    ) unless users_values.empty?
  end
  
  def object_count
    objects_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end
  
  def objects_scope(options={})
    raise NotImplementedError.new("You must implement #{name}.")
  end
end
