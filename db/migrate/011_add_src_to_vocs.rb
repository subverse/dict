class AddSrcToVocs < ActiveRecord::Migration
  def self.up
    add_column :vocs, :src, :string
  end

  def self.down
    remove_column :vocs, :src
  end
end
