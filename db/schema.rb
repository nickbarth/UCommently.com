# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121014183206) do

  create_table "users", :force => true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.string   "image"
    t.string   "access_token"
    t.integer  "videos_count", :default => 0, :null => false
    t.integer  "score",        :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.string   "title",        :default => "", :null => false
    t.string   "image",        :default => "", :null => false
    t.string   "url",          :default => "", :null => false
    t.text     "top_comments", :default => "", :null => false
    t.integer  "score",        :default => 0,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "video_id",                  :null => false
    t.string   "user_ip",                   :null => false
    t.integer  "score",      :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
