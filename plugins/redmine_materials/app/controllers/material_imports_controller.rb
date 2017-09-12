class MaterialImportsController < ImporterMaterialController
  menu_item :materials
  helper :materials

  def klass
    MaterialImport
  end

  def importer_klass
    MaterialKernelImport
  end


  def instance_index
    project_materials_path(:project_id => @project)
  end
end
