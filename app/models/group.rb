class Group < ApplicationRecord
  has_many :users
  has_many :predictions, through: :users

  validates :name, presence: true
end