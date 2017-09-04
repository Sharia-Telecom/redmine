class CreateMaterialCycles < ActiveRecord::Migration
  def change
    create_table :material_cycles do |t|
      
      t.integer :project_id, index: true
      
      t.integer :material_id, index: true
      
      t.integer :issue_id, index: true

      t.string :stage, index: true

      t.string :event_type, index: true

      t.string :order_no

      t.string :direction

      t.string :location
      
      t.references :warehouse, index: true
      
      t.decimal :value, :precision => 10, :scale => 2

      t.string :outsider
      
      t.string :purpose

      t.integer :author_id
      
      t.timestamps :null => false

    end
  end
end