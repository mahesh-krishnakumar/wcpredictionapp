class Match < ApplicationRecord
  belongs_to :team_1, class_name: 'Team'
  belongs_to :team_2, class_name: 'Team'

  validates :kick_off, presence: true

  scope :open_for_prediction, -> { where('kick_off > ?', Time.now + 1.hour) }
  scope :locked_for_prediction, -> { where('kick_off < ?', Time.now + 1.hour) }
  scope :upcoming, -> { where(team_1_goals: nil) }
  scope :completed, -> { where.not(team_1_goals: nil) }

  def locked?
    Time.now >= (kick_off - 1.hour)
  end
end
