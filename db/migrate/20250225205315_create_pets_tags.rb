class CreatePetsTags < ActiveRecord::Migration[8.0]
  def change
    create_table :pets_tags do |t|
      t.references :pet, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
