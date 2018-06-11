class Group < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :predictions, through: :users

  validates :name, presence: true

  validates :code, presence: true

  before_create :generate_code

  def generate_code
    self.code = (0...6).map { (65 + rand(26)).chr }.join
  end
end