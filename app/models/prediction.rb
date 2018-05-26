class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user

  validates :match, presence: true
  validates :user, presence: true
  validates :team_1_goals, presence: true
  validates :team_2_goals, presence: true
  validates :decider, inclusion: { in: Match.valid_decider_types }, allow_nil: true

  def winner
    return if team_1_goals == team_2_goals
    team_1_goals > team_2_goals ? match.team_1 : match.team_2
  end

  def short_text
    match.knock_out? ? "#{team_1_goals}-#{team_2_goals}(#{decider_short_text(decider)})" : "#{team_1_goals}-#{team_2_goals}"
  end

  def decider_short_text(decider)
    {
      Match::DECIDER_TYPE_PENALTY => 'PS',
      Match::DECIDER_TYPE_EXTRA_TIME => 'ET',
      Match::DECIDER_TYPE_REGULAR_TIME => 'RT'
    }[decider]
  end
end
