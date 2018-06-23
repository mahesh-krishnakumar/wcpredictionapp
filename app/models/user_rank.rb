class UserRank < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :user, presence: true, uniqueness: { scope: :group }
  validates :group, uniqueness: { scope: :user }
end
