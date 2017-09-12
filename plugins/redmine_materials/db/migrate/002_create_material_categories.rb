class CreateMaterialCategories < ActiveRecord::Migration
  def change
    create_table :material_categories do |t|
      t.string :name, :null => false
      t.integer :position
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :code
    end
    
    add_index :material_categories, :lft
    add_index :material_categories, :rgt
  end
end
