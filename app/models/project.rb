class Project < ApplicationRecord

  belongs_to :user
  has_many :expenses

  validates :name, presence: true
  validates :user_id, presence: true

  def total_amount
    0
  end

  def outstanding_amount
    0
  end

end
