class CreateQuests < ActiveRecord::Migration
  def self.up
    create_table :quests do |t|
      t.integer :user, :voc, :ok, :rep
      t.timestamps
    end
  end

  def self.down
    drop_table :quests
  end
end
