class AddLatitudeLongitudeDistanceToShelters < ActiveRecord::Migration[8.0]
  def change
    add_column :shelters, :latitude, :float
    add_column :shelters, :longitude, :float
    add_column :shelters, :distance, :integer
  end
end
