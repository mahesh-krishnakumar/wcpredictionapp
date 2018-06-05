class Match < ApplicationRecord
  DECIDER_TYPE_REGULAR_TIME = -'Regular'
  DECIDER_TYPE_EXTRA_TIME = -'Extra Time'
  DECIDER_TYPE_PENALTY = -'Penalty'

  def self.valid_decider_types
    [DECIDER_TYPE_REGULAR_TIME, DECIDER_TYPE_EXTRA_TIME, DECIDER_TYPE_PENALTY].freeze
  end

  validates :kick_off, presence: true
  validates :decider, inclusion: { in: valid_decider_types }, allow_blank: true

  STAGE_GROUP = -'group'
  STAGE_PRE_QUARTER = -'pre_quarter'
  STAGE_QUARTER = -'quarter'
  STAGE_SEMI_FINAL = -'semi_final'
  STAGE_FINAL = -'final'

  def self.valid_stages
    [STAGE_GROUP, STAGE_PRE_QUARTER, STAGE_QUARTER, STAGE_SEMI_FINAL, STAGE_FINAL].freeze
  end

  validates :stage, inclusion: { in: valid_stages }

  belongs_to :team_1, class_name: 'Team'
  belongs_to :team_2, class_name: 'Team'

  validate :have_decider_only_for_knockout
  validate :both_teams_should_have_goals
  validate :equal_goals_only_for_shootout
  validate :set_winner_only_for_shootout_matches
  validate :shootout_should_be_a_draw
  validate :winner_must_be_present_for_penalty

  scope :unlocked, -> { where(locked: false) }
  scope :open_for_prediction, -> { unlocked.where('kick_off > ?', Time.now + 15.minutes) }
  scope :locked_for_prediction, -> { where('kick_off < ?', Time.now + 15.minutes) }
  scope :closing_soon, -> { open_for_prediction.where('kick_off < ?', 1.day.from_now) }
  scope :upcoming, -> { where(team_1_goals: nil) }
  scope :completed, -> { where.not(team_1_goals: nil) }

  scope :group_stage, -> { where(stage: STAGE_GROUP) }
  scope :knock_out_stage, -> { where(stage: [STAGE_PRE_QUARTER, STAGE_QUARTER, STAGE_SEMI_FINAL, STAGE_FINAL]) }

  def locked?
    Time.now >= (kick_off - 15.minutes)
  end

  def have_decider_only_for_knockout
    errors.add(:decider, 'Select decider for knockout match') if knock_out? && decider.blank? && team_1_goals.present?
    errors.add(:decider, 'Decider is only applicable for group matches') if !knock_out? && decider.present? && team_1_goals.present?
  end

  def both_teams_should_have_goals
    if team_1_goals.present? && !team_2_goals.present?
      errors.add(:team_2_goals, 'Goals should be updated for both teams')
    elsif team_2_goals.present? && !team_1_goals.present?
      errors.add(:team_1_goals, 'Goals should be updated for both teams')
    end
  end

  def equal_goals_only_for_shootout
    return if Match::STAGE_GROUP || team_1_goals.blank?
    return if team_1_goals != team_2_goals
    return if decider == DECIDER_TYPE_PENALTY
    errors.add(:team_1_goals, 'Draw score only if decider is penalty')
  end

  def shootout_should_be_a_draw
    return if decider != DECIDER_TYPE_PENALTY
    return if team_1_goals == team_2_goals
    errors.add(:team_1_goals, 'Penalty should have a draw score')
  end

  def set_winner_only_for_shootout_matches
    return if winner_id.blank?
    return if knock_out? && (decider == DECIDER_TYPE_PENALTY)
    errors.add(:winner_id, 'Set winner only if result was from a penalty shootout')
  end

  def winner_must_be_present_for_penalty
    return if decider != DECIDER_TYPE_PENALTY
    return if winner_id.present?
    errors.add(:winner_id, 'Set winner for a penalty shootout')
  end

  def ongoing?
    Time.now.between?(kick_off, kick_off + 2.hours)
  end

  def winner
    if winner_id.present?
      Team.find(winner_id)
    else
      return if team_1_goals == team_2_goals
      team_1_goals > team_2_goals ? team_1 : team_2
    end
  end

  def knock_out?
    stage.in? [STAGE_PRE_QUARTER, STAGE_QUARTER, STAGE_SEMI_FINAL, STAGE_FINAL]
  end

  def score_as_string
    "#{team_1_goals}-#{team_2_goals}"
  end

  def completed?
    team_1_goals.present?
  end

  def short_text
    knock_out? ? "#{team_1_goals}-#{team_2_goals}(#{decider_short_text(decider)})" : "#{team_1_goals}-#{team_2_goals}"
  end

  def decider_short_text(decider)
    {
      Match::DECIDER_TYPE_PENALTY => 'PS',
      Match::DECIDER_TYPE_EXTRA_TIME => 'ET',
      Match::DECIDER_TYPE_REGULAR_TIME => 'RT'
    }[decider]
  end

  def summary_text
    winner.present? ? "#{winner.full_name} (#{short_text})" : "Draw (#{short_text})"
  end
end
