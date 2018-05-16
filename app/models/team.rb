class Team < ApplicationRecord
  validates :full_name, presence: true
  validates :short_name, presence: true

  has_one_attached :flag
end
