class ChangeCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :note, :text
  end
 
  def self.down
    remove_column :categories, :note
	end
end

