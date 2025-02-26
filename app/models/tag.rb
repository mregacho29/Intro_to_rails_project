class Tag < ApplicationRecord
  has_many :pets_tags
  has_many :pets, through: :pets_tags

  validates :name, presence: true
end
