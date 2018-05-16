class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user
  belongs_to :winner, class_name: 'Team', optional: true

  validates :match, presence: true
  validates :user, presence: true
end
