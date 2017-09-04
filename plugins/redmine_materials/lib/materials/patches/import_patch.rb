module RedmineMaterials
  module Patches
    module ImportPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
        end
      end

      module InstanceMethods
        def project=(project)
          settings['project'].present? ? settings['project'] = project.id : settings.merge!('project' => project.id)
        end

        def project
          settings['project']
        end
      end
    end
  end
end

unless Import.included_modules.include?(RedmineMaterials::Patches::ImportPatch)
  Import.send(:include, RedmineMaterials::Patches::ImportPatch)
end
