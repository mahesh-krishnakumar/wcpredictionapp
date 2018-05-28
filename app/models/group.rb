class Group < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :predictions, through: :users

  validates :name, presence: true
end