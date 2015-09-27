class QuestionTotalVotes < ActiveRecord::Migration
  def change
    add_column :questions, :total_votes, :integer
  end
end

