class Shelter < ApplicationRecord
  has_many :pets

  validates :shelter_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :website, presence: true
end
