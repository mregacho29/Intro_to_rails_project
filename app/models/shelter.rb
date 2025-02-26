class Shelter < ApplicationRecord
  has_many :pets

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :website, presence: true
end
