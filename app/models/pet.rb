class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :pets_tags
  has_many :tags, through: :pets_tags

  validates :name, presence: true
  validates :animal_type, presence: true
  validates :breed, presence: true
  validates :age, presence: true
  validates :size, presence: true
  validates :gender, presence: true
  validates :status, presence: true
  validates :shelter_id, presence: true
end
