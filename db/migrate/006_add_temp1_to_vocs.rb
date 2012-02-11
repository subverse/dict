class AddTemp1ToVocs < ActiveRecord::Migration
  def self.up
    add_column :vocs, :temp1, :integer
  end

  def self.down
    remove_column :vocs, :temp1
  end
end
