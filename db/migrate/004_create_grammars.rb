class CreateGrammars < ActiveRecord::Migration
  def self.up
    create_table :grammars do |t|
      t.string :grm
			t.text :note
      t.timestamps
    end
  end

  def self.down
    drop_table :grammars
  end
end
