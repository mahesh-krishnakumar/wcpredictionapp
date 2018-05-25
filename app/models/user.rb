class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :predictions
  belongs_to :group

  validates :group, presence: true
  validates :name, presence: true
  validates :nick_name, presence: true
end
