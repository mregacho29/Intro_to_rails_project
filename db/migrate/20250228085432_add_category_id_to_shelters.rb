class AddCategoryIdToShelters < ActiveRecord::Migration[8.0]
  def change
    add_column :shelters, :category_id, :integer
  end
end
