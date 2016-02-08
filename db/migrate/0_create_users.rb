class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :email, :password_hash
    end

    create_table :tasks do |t|
      t.belongs_to :user, index: true
      t.belongs_to :page, index: true
      t.string :name
      t.integer :frequency
    end

    create_table :pages do |t|
      t.string :url
      t.datetime :last_updated
    end
  end
end
