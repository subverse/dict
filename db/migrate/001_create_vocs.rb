class CreateVocs < ActiveRecord::Migration
  def self.up
    create_table :vocs do |t|
      t.string :german
      t.string :wylie
      t.string :grm
      t.string :cat
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :vocs
  end
end
