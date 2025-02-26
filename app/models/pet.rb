class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :pets_tags
  has_many :tags, through: :pets_tags
end
