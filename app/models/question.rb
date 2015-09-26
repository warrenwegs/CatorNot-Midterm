class Question < ActiveRecord::Base

  belongs_to :item1, :class_name => 'Item'
  belongs_to :item2, :class_name => 'Item'
  has_many :items
  has_many :tags
  has_many :votes
  has_many :comments

  validates :category, :item1, :item2, presence: true

  def update_score
    total_votes = votes.count
    item1_votes = votes.where(item_id: item1.id).count
    update_attributes(item1_score: (item1_votes.to_f / total_votes.to_f).to_f) if total_votes > 0
  end

end
