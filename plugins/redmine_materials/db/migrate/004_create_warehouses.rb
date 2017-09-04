class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|

      t.string :code

      t.string :name

      t.string :type

      t.string :location

      t.integer :responsible_by_id

      t.integer :author_id

      t.date :found_date

      t.string :status

      t.text :description
      
      t.timestamps null: false

    end

  end
end
