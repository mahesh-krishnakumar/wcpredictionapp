class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user
  belongs_to :winner, class_name: 'Team', optional: true

  validates :match, presence: true
  validates :user, presence: true
  validates :team_1_goals, presence: true
  validates :team_2_goals, presence: true
  validates :decider, inclusion: { in: Match.valid_decider_types }, allow_nil: true

  def winner
    return if team_1_goals == team_2_goals
    team_1_goals > team_2_goals ? match.team_1 : match.team_2
  end
end
