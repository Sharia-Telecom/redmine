module RedmineMaterials
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          has_one :material_cycle

          accepts_nested_attributes_for :material_cycle
          
          safe_attributes 'material_cycle_attributes',
            :if => lambda {|issue, user| user.allowed_to?(:new_material_cycles, issue.project) || user.allowed_to?(:edit_material_cycles, issue.project)}

        end
      end

    end
  end
end

unless Issue.included_modules.include?(RedmineMaterials::Patches::IssuePatch)
  Issue.send(:include, RedmineMaterials::Patches::IssuePatch)
end
