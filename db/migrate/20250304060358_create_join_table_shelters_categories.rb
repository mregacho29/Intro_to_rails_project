class CreateJoinTableSheltersCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :shelters, :categories do |t|
      t.index :shelter_id
      t.index :category_id
    end
  end
end
