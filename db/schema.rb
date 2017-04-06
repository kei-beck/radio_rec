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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151224023230) do

  create_table "keywords", force: :cascade do |t|
    t.string   "keyword"
    t.boolean  "title_flg"
    t.boolean  "sub_title_flg"
    t.boolean  "performer_flg"
    t.boolean  "description_flg"
    t.boolean  "information_flg"
    t.boolean  "twitter_flg"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "programs", force: :cascade do |t|
    t.integer  "station_id"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "air_time"
    t.string   "title"
    t.string   "sub_title"
    t.string   "performer"
    t.string   "description"
    t.string   "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "station_id"
    t.integer  "program_id"
    t.string   "start_time"
    t.string   "air_time"
    t.string   "title"
    t.string   "performer"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string   "radiko_station_id"
    t.string   "radiru_station_id"
    t.string   "name"
    t.string   "ascii_name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
