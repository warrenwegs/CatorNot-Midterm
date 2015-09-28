class Question < ActiveRecord::Base

  belongs_to :item1, :class_name => 'Item'
  belongs_to :item2, :class_name => 'Item'
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :category, :item1, :item2, presence: true
  after_create :count_votes
  

  def update_score
    item1_votes = votes.where(item_id: item1.id).count
    update_attributes(item1_score: (item1_votes.to_f / total_votes.to_f).to_f) if total_votes > 0
  end

  def item1_votes
    votes.where(item_id: item1.id).count
  end

  def item2_votes
    votes.where(item_id: item2.id).count
  end

  def count_votes
    total = Vote.group(:question_id).count[id]
    total = total ? total : 0
    update_attributes(total_votes: total)
  end

end
