class User < ActiveRecord::Base

  has_many :votes
  has_many :questions

end