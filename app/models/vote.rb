class Vote < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  belongs_to :item

  after_create :update_question_score

  def update_question_score
    question.update_score
  end
end