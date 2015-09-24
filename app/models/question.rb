class Question < ActiveRecord::Base

  belongs_to :item1, :class_name => 'Item'
  belongs_to :item2, :class_name => 'Item'
  has_many :items
  has_many :tags
  has_many :votes

  validates :category, presence: true

end