class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user

  validates :match, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true
  validates :team_1_goals, presence: true, inclusion: { in: 0..99 }
  validates :team_2_goals, presence: true, inclusion: { in: 0..99 }
  validates :decider, inclusion: { in: Match.valid_decider_types }, allow_nil: true

  validate :set_winner_only_for_shootout_matches

  def set_winner_only_for_shootout_matches
    return if winner_id.blank?
    return if decider == Match::DECIDER_TYPE_PENALTY
    errors.add(:winner_id, 'Set winner only if predicted decider is a penalty shootout')
  end

  validate :winner_must_be_present_for_penalty

  def winner_must_be_present_for_penalty
    return if decider != Match::DECIDER_TYPE_PENALTY
    return if winner_id.present?
    errors.add(:winner_id, 'Select winner for a penalty decider')
  end

  validate :allow_draw_only_if_decider_is_penalty

  def allow_draw_only_if_decider_is_penalty
    return if decider != Match::DECIDER_TYPE_PENALTY
    return if team_1_goals == team_2_goals
    errors.add(:team_1_goals, 'Only draw is allowed if selected decider is penalty')
  end

  validate :do_not_allow_draw_for_regular_and_extra_time

  def do_not_allow_draw_for_regular_and_extra_time
    return if match.stage == Match::STAGE_GROUP
    return if decider == Match::DECIDER_TYPE_PENALTY
    return if team_1_goals != team_2_goals
    errors.add(:team_1_goals, 'Draw is only allowed if selected decider is penalty')
  end

  def winner
    if winner_id.present?
      Team.find(winner_id)
    else
      return if team_1_goals == team_2_goals
      team_1_goals > team_2_goals ? match.team_1 : match.team_2
    end
  end

  def decider_short_text(decider)
    {
      Match::DECIDER_TYPE_PENALTY => 'PS',
      Match::DECIDER_TYPE_EXTRA_TIME => 'ET',
      Match::DECIDER_TYPE_REGULAR_TIME => 'RT'
    }[decider]
  end

  def score_as_string
    "#{team_1_goals}-#{team_2_goals}"
  end

  before_save :set_short_and_summary_texts

  def set_short_and_summary_texts
    self.short_text = match.knock_out? ? "#{team_1_goals}-#{team_2_goals}, #{decider_short_text(decider)}" : "#{team_1_goals}-#{team_2_goals}"
    self.short_text = winner.short_name + ' ' + self.short_text if self.decider == Match::DECIDER_TYPE_PENALTY
    self.summary_text = winner.present? ? "#{winner.short_name} (#{short_text})" : "Draw (#{short_text})"
    self.summary_text = "#{winner.short_name} (#{team_1_goals}-#{team_2_goals}, PS)" if self.decider == Match::DECIDER_TYPE_PENALTY
  end
end
