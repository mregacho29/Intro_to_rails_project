class PetsTag < ApplicationRecord
  belongs_to :pet
  belongs_to :tag
end
