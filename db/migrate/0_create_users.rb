class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :email, :password_hash, :slack_url, :slack_bot_name
      t.belongs_to :platform
    end

    create_table :tasks do |t|
      t.belongs_to :user, index: true
      t.belongs_to :page, index: true
      t.string :name, :selector
      t.integer :frequency
      t.datetime :last_updated
    end

    create_table :pages do |t|
      t.string :url
    end

    create_table :platforms do |t|
      t.string :name
    end

    Platform.create(name: 'Email')
    Platform.create(name: 'Slack')
  end
end
