class PetsTag < ApplicationRecord
  belongs_to :pet
  belongs_to :tag

  validates :pet_id, presence: true
  validates :tag_id, presence: true
end
