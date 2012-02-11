class AddLengthToVocs < ActiveRecord::Migration
  def self.up
    add_column :vocs, :length, :integer
  end

  def self.down
    remove_column :vocs, :length
  end
end