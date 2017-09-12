class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :inner_code

      t.integer :parent_material_id, index: true

      t.string :name

      t.string :brand

      t.integer :category_id
      
      t.decimal :amount, :precision => 10, :scale => 2

      t.decimal :original_value, :precision => 10, :scale => 2

      t.decimal :current_value, :precision => 10, :scale => 2

      t.timestamp :purchase_at

      t.text :detail

      t.string :device_no

      t.string :property

      t.integer :handover_id, index: true
      
      t.timestamp :handover_at

      t.integer :user_id, index: true

      t.integer :purchaser_id

      t.timestamp :use_since

      t.string :location

      t.timestamp :location_since

      t.integer :owner_id, index: true

      t.integer :responsible_by_id, index: true

      t.integer :author_id, index: true

      t.integer :project_id, index: true

      t.text :remark
      
      t.string :status

      t.timestamps null: false

    end

  end
end
