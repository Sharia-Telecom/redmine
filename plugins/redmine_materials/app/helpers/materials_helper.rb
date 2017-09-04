module MaterialsHelper
  def material_categories_for_select(selected = nil)
    @material_categories ||= MaterialCategory.order(:lft).all
  end

  def material_types_for_select
    s = ''
    s.html_safe
  end

  def material_category_tree_options_for_select(material_categories, options = {})
    s = ''
    MaterialCategory.category_tree(material_categories) do |material_category, level|
      name_prefix = (level > 0 ? '&nbsp;' * 2 * level + '&#187; ' : '').html_safe
      tag_options = {:value => material_category.id}
      if material_category == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(material_category))
        tag_options[:selected] = 'selected'
      else
        tag_options[:selected] = nil
      end
      tag_options.merge!(yield(material_category)) if block_given?
      s << content_tag('option', name_prefix + h(material_category.name), tag_options)
    end
    s.html_safe
  end

  def material_category_url(category_id, options={})
    {:controller => 'materials',
     :action => 'index',
     :set_filter => 1,
     :project_id => @project,
     :fields => [:category_id],
     :values => {:category_id => [category_id]},
     :materials => {:category_id => '='}}.merge(options)
  end

  def material_category_tree_tag(material, options={})
    return "" if material.category.blank?
    material.category.self_and_ancestors.map do |category|
      link_to category.name, material_category_url(category.id, options)
    end.join(' &#187; ').html_safe
  end

  # define the status' enum list
  def collection_for_status_select
    [[l(:label_material_status_normal), Material::STATUS_NORMAL],
     [l(:label_material_status_useless), Material::STATUS_USELESS],
     [l(:label_material_status_lock), Material::STATUS_LOCK],
     [l(:label_material_status_other), Material::STATUS_OTHER]]
  end
  
  # define the property's enum list
  def collection_for_property_select
    [[l(:label_material_property_inner), Material::PROPERTY_INNER],
     [l(:label_material_property_outside), Material::PROPERTY_OUTSIDE],
     [l(:label_material_property_personal), Material::PROPERTY_PERSONAL],
     [l(:label_material_property_other), Material::PROPERTY_OTHER]]
  end
  
  def materials_to_csv(materials)
    if materials.nil?
      return
    end
    decimal_separator = l(:general_csv_decimal_separator)
    encoding = l(:general_csv_encoding)
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      headers = [ "#",
                  'Inner Code',
                  'Name',
                  'Category',
                  'Parent',
                  'Brand',
                  'Amount',
                  'Original Value',
                  'Current Value',
                  'User',
                  'Use Since',
                  'Purchaser',
                  'Purchase At',
                  'Handover',
                  'Handover At',
                  'Location',
                  'Locate Since',
                  'Responsible By',
                  'Owner',
                  'Device No',
                  'Status',
                  'Property',
                  'Remark',
                  'Details',
                  'Author',
                  'Created At',
                  'Updated At'
                  ]

      csv << headers.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      # csv lines
      materials.each do |material|
        fields = [material.id,
                  material.inner_code,
                  material.name,
                  material.category ? material.category.name : "",
                  material.parent_material_id ? material.parent_material.name : "",
                  material.brand,
                  material.amount,
                  material.original_value,
                  material.current_value,
                  material.user_id ? material.user.name : "",
                  material.use_since,
                  material.purchaser_id ? material.purchaser.name : "",
                  material.purchase_at,
                  material.handover_id ? material.handover.name : "",
                  material.handover_at,
                  material.location,
                  material.location_since,
                  material.responsible_by_id ? material.responsible_by.name : "",
                  material.owner_id ? material.owner.name : "",
                  material.device_no,
                  material.status,
                  material.property,
                  material.remark,
                  material.detail,
                  material.author_id ? material.author.name : "",
                  format_time(material.created_at),
                  format_time(material.updated_at)
                  ]
        csv << fields.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      end
    end
    export
  end
  
  def importer_link
    project_material_imports_path
  end

  def importer_show_link(importer, project)
    project_material_import_path(:id => importer, :project_id => project)
  end

  def importer_settings_link(importer, project)
    settings_project_material_import_path(:id => importer, :project => project)
  end

  def importer_run_link(importer, project)
    run_project_material_import_path(:id => importer, :project_id => project, :format => 'js')
  end

  def link_to_material(material)
    link_to material.name, material_path(material)
  end

end
