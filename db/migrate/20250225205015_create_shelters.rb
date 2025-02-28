class CreateShelters < ActiveRecord::Migration[8.0]
  def change
    create_table :shelters do |t|
      t.string :shelter_id, null: false, unique: true
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :website
      t.float :latitude
      t.float :longitude
      t.integer :distance

      t.timestamps
    end
    add_index :shelters, :shelter_id, unique: true
  end
end
