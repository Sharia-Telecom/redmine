module RedmineMaterials
  module Patches

    module IssuesControllerPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          helper :material_cycles
          
          alias_method_chain :build_new_issue_from_params, :material_cycle
        end
      end

      module InstanceMethods
        def build_new_issue_from_params_with_material_cycle
          build_new_issue_from_params_without_material_cycle

          return if @issue.blank?
          
          # initial
          if !params[:material_id].blank?
            material_id = params[:material_id]
            @material = Material.find_by_id(material_id)
            
            material_cycle_stage = params[:material_cycle_stage]          
            
            if material_cycle_stage == MaterialCycle::STAGE_ENTRY
              (render_403; return false) unless @material.can_cycle_entry?
            end
            
            if material_cycle_stage == MaterialCycle::STAGE_MIDDLE
              (render_403; return false) unless @material.can_cycle_middle?
            end
            
            if material_cycle_stage == MaterialCycle::STAGE_EXIT
              (render_403; return false) unless @material.can_cycle_exit?
            end
            @material_cycle = @material.material_cycles.build
            @material_cycle.project = @project
            @material_cycle.stage = material_cycle_stage
            @material_cycle.author = User.current
            @material_cycle.issue = @issue
            
            @issue.subject = "#{l(:label_material)}##{@material.id}#{@material_cycle.stage_name}:"
          end
          
          # edit a material cycle, need issue link
          if !params[:material_cycle_id].blank?
            material_cycle_id = params[:material_cycle_id]
            @material_cycle = MaterialCycle.find_by_id(material_cycle_id)
            @material_cycle.issue = @issue
            
            @issue.subject = "#{l(:label_material)}##{@material_cycle.material_id}#{@material_cycle.stage_name}:"
          end
        end
      end
    end
  end
end

unless IssuesController.included_modules.include?(RedmineMaterials::Patches::IssuesControllerPatch)
  IssuesController.send(:include, RedmineMaterials::Patches::IssuesControllerPatch)
end
