class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :predictions
  has_and_belongs_to_many :groups, after_add: :update_ranks_and_points, after_remove: :update_ranks_and_points
  belongs_to :team, optional: true # her favourite team

  # validates :group, presence: true
  validates :name, presence: true
  validates :nick_name, presence: true

  after_create :update_ranks_and_points

  def update_ranks_and_points(_group = nil)
    Users::UpdateRanksService.new.execute
  end
end
