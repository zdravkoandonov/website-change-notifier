class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :email, :password_hash
    end

    create_table :tasks do |t|
      t.string :url
      t.integer :frequency
    end

    create_table :tasks_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
    end
  end
end
