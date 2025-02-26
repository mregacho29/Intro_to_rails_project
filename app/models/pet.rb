class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :pets_tags
  has_many :tags, through: :pets_tags

  validates :pet_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :type, presence: true
  validates :breed, presence: true
  validates :age, presence: true
  validates :size, presence: true
  validates :gender, presence: true
  validates :status, presence: true
end
