class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :question

  validates :text, presence: true

end