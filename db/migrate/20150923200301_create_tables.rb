class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :email
      t.string :password
      t.timestamps
    end

    create_table :items do |t|
      t.references :question
      t.string :name
      t.string :url
    end

    create_table :questions do |t|
      t.references :user
      t.references :item1
      t.references :item2
      t.decimal :item1_score
      t.string :category
      t.timestamps
    end

    create_table :comments do |t|
      t.references :question
      t.references :user
      t.string :text
      t.timestamps
    end

    create_table :votes do |t|
      t.references :user
      t.references :question
      t.references :item
      t.timestamps
    end
  end
end

