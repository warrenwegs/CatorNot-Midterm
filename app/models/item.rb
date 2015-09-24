class Item < ActiveRecord::Base

  belongs_to :question

  validates :name, :url, presence: true
  
end
