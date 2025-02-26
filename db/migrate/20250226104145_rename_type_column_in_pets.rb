class RenameTypeColumnInPets < ActiveRecord::Migration[8.0]
  def change
    rename_column :pets, :type, :animal_type
  end
end
