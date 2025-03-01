class Shelter < ApplicationRecord
  belongs_to :category, optional: true
  has_many :pets

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
end
