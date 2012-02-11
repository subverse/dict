class CreateTemps < ActiveRecord::Migration
  def self.up
    create_table :temps do |t|
	  t.string :user
	  t.integer :sentence
      t.string :german
	  t.string :wylie
	  t.string :grm
	  t.string :cat	  
	  t.text :note	  
      t.timestamps
    end
  end

  def self.down
    drop_table :temps
  end
end
