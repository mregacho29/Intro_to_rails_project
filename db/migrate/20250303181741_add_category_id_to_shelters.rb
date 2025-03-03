class AddCategoryIdToShelters < ActiveRecord::Migration[8.0]
  def change
    add_column :shelters, :category_id, :integer
    add_foreign_key :shelters, :categories
  end
end
