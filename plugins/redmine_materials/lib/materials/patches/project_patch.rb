module RedmineMaterials
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc: 
        base.class_eval do    
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :materials, :dependent => :destroy 
          has_many :material_cycles, :dependent => :destroy 
        end  
      end  
    end
  end
end

unless Project.included_modules.include?(RedmineMaterials::Patches::ProjectPatch)
  Project.send(:include, RedmineMaterials::Patches::ProjectPatch)
end
