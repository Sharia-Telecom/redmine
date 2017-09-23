require 'redmine'

if ActiveRecord::VERSION::MAJOR >= 4
  require 'csv'
  FCSV = CSV
end

Redmine::Plugin.register :redmine_materials do
  name 'Redmine Materials plugin'
  author 'Tigergm Wu, Modified by Sharia Founder'
  description 'This is a plugin of materials for Redmine'
  version '0.1.6'
  url 'https://bitbucket.org/39648421/redmine_materials'
  author_url 'https://bitbucket.org/39648421'
  
  requires_redmine :version_or_higher => '3.2'
  
  project_module :redmine_materials do
    permission :new_materials, :materials => [:new, :create]
    permission :show_materials, :materials => [:show, :index]
    permission :edit_materials, :materials => :edit
    permission :delete_materials, :materials => :destroy

    permission :import_materials, {:material_imports => [:new, :create, :show, :settings, :mapping, :run]}    
    
    permission :comment_materials, {:material_comments => :create}
    permission :delete_material_comments, {:material_comments => :destroy}

    permission :new_material_cycles, :material_cycles => [:new, :create, :entry, :middle, :exit]
    permission :show_material_cycles, :material_cycles => [:show, :index]
    permission :edit_material_cycles, :material_cycles => :edit
    permission :delete_material_cycles, :material_cycles => :destroy
  end
  
  menu :top_menu, :materials, {:controller => 'materials', :action => 'index', :project_id => nil}, :caption => :label_materials, :if => Proc.new {
    User.current.allowed_to?({:controller => 'materials', :action => 'index'}, nil, {:global => true}) && RedmineMaterials.settings[:show_in_top_menu].to_i > 0
  }
  
  menu :admin_menu, :materials, {:controller => 'settings', :action => 'plugin', :id => "redmine_materials"}, :caption => :label_materials, :html => {:class => 'icon'}
  
  menu :project_menu, :materials, {:controller => 'materials', :action => 'index'}, :caption => :label_materials, :param => :project_id

  settings :default => {
  }, :partial => 'settings/materials'
  
  activity_provider :materials, :default => false, :class_name => ['Material']
  activity_provider :material_cycles, :default => false, :class_name => ['MaterialCycle']
  
  Redmine::Search.map do |search|
    search.register :materials
  end

end

ActionDispatch::Callbacks.to_prepare do
  require 'redmine_materials'
end
