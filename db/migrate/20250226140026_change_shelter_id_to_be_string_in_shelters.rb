class ChangeShelterIdToBeStringInShelters < ActiveRecord::Migration[8.0]
  def change
    change_column :shelters, :shelter_id, :string
  end
end
