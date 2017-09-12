module RedmineMaterials
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_details_bottom, :partial => 'material_cycles/issue_cycle_show'
      render_on :view_issues_form_details_top, :partial => 'material_cycles/issue_cycle'
    end
  end
end
