class Expense < ApplicationRecord

  belongs_to :project
  belongs_to :payment_type
  belongs_to :expense_type
  belongs_to :currency

  validates :project, presence: true
  validates :payment_type, presence: true
  validates :expense_type, presence: true
  validates :currency, presence: true
  validates :expense_date, presence: true
  validates :amount, presence: true

end
