  
  # patches
  require_dependency 'materials/patches/project_patch'
  require_dependency 'materials/patches/issue_patch'
  require_dependency 'materials/patches/auto_completes_controller_patch'
  require_dependency 'materials/patches/issues_controller_patch'
  require_dependency 'materials/patches/import_patch'
  
  # Hooks
  require_dependency 'materials/hooks/views_issues_hook'
  require_dependency 'materials/hooks/view_layouts_hook'


module RedmineMaterials
  
  def self.settings() Setting[:plugin_redmine_materials].blank? ? {} : Setting[:plugin_redmine_materials]  end

  module Hooks
    class ViewLayoutsBaseHook < Redmine::Hook::ViewListener
      render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag :materials, :plugin => 'redmine_materials' %>"
    end
  end

end
