require_dependency 'auto_completes_controller'

module RedmineMaterials
  module Patches
    module AutoCompletesControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
        end
      end

      module InstanceMethods
        def materials
          @materials = []
          q = (params[:q] || params[:term]).to_s.strip
          if q.present?
            scope = Material.joins(:project).where({})
            scope = scope.limit(params[:limit] || 10)
            scope = scope.by_project(@project) if @project
            if q.match(/\A#?(\d+)\z/)
              @materials << scope.visible.find_by_id($1.to_i)
            end
            q.split(' ').collect{ |search_string| scope = scope.live_search(search_string) }
            @materials += scope.visible.order("#{Material.table_name}.name")
            @materials.compact!
          end
          render :layout => false, :partial => 'materials'
        end
      end
    end
  end
end

unless AutoCompletesController.included_modules.include?(RedmineMaterials::Patches::AutoCompletesControllerPatch)
  AutoCompletesController.send(:include, RedmineMaterials::Patches::AutoCompletesControllerPatch)
end
