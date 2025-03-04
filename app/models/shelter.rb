class Shelter < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :pets

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
end
