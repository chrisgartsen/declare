class User < ApplicationRecord

  before_save :encrypt_password

  attr_accessor :password

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  has_many :projects

  def activate
    self.active = true
  end

  def inactivate
    self.active = false
  end

  def authenticate(password)
    self.password_hash == self.hash_password(password)
  end

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = self.hash_password(self.password)
  end

  def hash_password(password)
    BCrypt::Engine.hash_secret(password, self.password_salt)
  end

  def number_of_projects
    self.projects.count
  end

  def expenses
    @expenses = []
    self.projects.each do | project |
      @expenses += project.expenses.to_a
    end
    return @expenses
  end


end
