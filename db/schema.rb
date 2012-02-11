# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "categories", :force => true do |t|
    t.string   "cat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
  end

  create_table "grammars", :force => true do |t|
    t.string   "grm"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quests", :force => true do |t|
    t.integer  "user"
    t.integer  "voc"
    t.integer  "ok"
    t.integer  "rep"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temps", :force => true do |t|
    t.string   "user"
    t.integer  "sentence"
    t.string   "german"
    t.string   "wylie"
    t.string   "grm"
    t.string   "cat"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "pw"
    t.integer  "access"
    t.integer  "logins"
    t.integer  "logouts"
  end

  create_table "vocs", :force => true do |t|
    t.string   "german",    :default => "", :null => false
    t.string   "wylie",     :default => "", :null => false
    t.string   "grm",       :default => "", :null => false
    t.string   "cat",       :default => "", :null => false
    t.text     "note",                      :null => false
    t.datetime "timestamp"
    t.integer  "temp1"
    t.integer  "length"
    t.string   "src"
  end

end
