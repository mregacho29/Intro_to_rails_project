class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.integer :pet_id
      t.string :name
      t.string :type
      t.string :breed
      t.string :age
      t.string :size
      t.string :gender
      t.string :status
      t.text :photo_urls
      t.references :shelter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
