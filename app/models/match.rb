class Match < ApplicationRecord
  DECIDER_TYPE_REGULAR_TIME = -'Regular'
  DECIDER_TYPE_EXTRA_TIME = -'Extra Time'
  DECIDER_TYPE_PENALTY = -'Penalty'

  def self.valid_decider_types
    [DECIDER_TYPE_REGULAR_TIME, DECIDER_TYPE_EXTRA_TIME, DECIDER_TYPE_PENALTY].freeze
  end

  validates :kick_off, presence: true
  validates :decider, inclusion: { in: valid_decider_types }, allow_blank: true

  belongs_to :team_1, class_name: 'Team'
  belongs_to :team_2, class_name: 'Team'

  validate :have_decider_only_for_knockout


  scope :open_for_prediction, -> { where('kick_off > ?', Time.now + 1.hour) }
  scope :locked_for_prediction, -> { where('kick_off < ?', Time.now + 1.hour) }
  scope :upcoming, -> { where(team_1_goals: nil) }
  scope :completed, -> { where.not(team_1_goals: nil) }

  def locked?
    Time.now >= (kick_off - 1.hour)
  end

  def have_decider_only_for_knockout
    errors.add(:decider, 'Select decider for knockout match') if knock_out && decider.blank? && team_1_goals.present?
    errors.add(:decider, 'Decider is only applicable for group matches') if !knock_out && decider.present? && team_1_goals.present?
  end

  def ongoing?
    Time.now.between?(kick_off, kick_off + 2.hours)
  end
end
