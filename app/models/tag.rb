class Tag < ApplicationRecord
  has_many :pets_tags
  has many :pets, through: :pets_tags

  validates :name, presence: true
end
