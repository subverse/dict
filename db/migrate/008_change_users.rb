class ChangeUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
	add_column :users, :pw, :string
	add_column :users, :access, :integer
    add_column :users, :logins, :integer
	add_column :users, :logouts, :integer
  end
 
  def self.down
    remove_column :users, :name
	remove_column :users, :pw
	remove_column :users, :access
	remove_column :users, :logins
	remove_column :users, :logouts
  end
end

