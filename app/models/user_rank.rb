class UserRank < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :user, presence: true, uniqueness: { scope: :group }
  validates :group, uniqueness: { scope: :user }
  validates :points, presence: true
  validates :rank, presence: true
end
