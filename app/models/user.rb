class User < ActiveRecord::Base

  has_many :votes
  has_many :questions

  validates :first_name, :last_name, :user_name, :email, presence: true
  has_secure_password

end