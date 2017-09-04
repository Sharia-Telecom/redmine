class AddCommentsCountToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :comments_count, :integer
  end
end
