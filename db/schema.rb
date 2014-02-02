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

ActiveRecord::Schema.define(version: 6) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "cards", force: true do |t|
    t.string   "name"
    t.string   "names",                  array: true
    t.string   "mana_cost"
    t.integer  "cmc"
    t.string   "colors",                 array: true
    t.string   "type_text"
    t.string   "supertypes",             array: true
    t.string   "card_types",             array: true
    t.string   "subtypes",               array: true
    t.text     "text"
    t.string   "power"
    t.string   "toughness"
    t.string   "layout"
    t.integer  "vanguard_hand_modifier"
    t.integer  "vanguard_life_modifier"
    t.hstore   "foreign_names"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "editions", force: true do |t|
    t.integer  "card_id"
    t.integer  "mtg_set_id"
    t.text     "flavor"
    t.string   "border"
    t.string   "watermark"
    t.string   "rarity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "editions", ["card_id"], name: "index_editions_on_card_id", using: :btree
  add_index "editions", ["mtg_set_id"], name: "index_editions_on_mtg_set_id", using: :btree

  create_table "mtg_sets", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.date     "release_date"
    t.string   "border"
    t.string   "release_type"
    t.string   "block"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "printings", force: true do |t|
    t.integer  "edition_id"
    t.integer  "multiverse_id"
    t.string   "mtgimage_name"
    t.integer  "number"
    t.string   "artist"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "printings", ["edition_id"], name: "index_printings_on_edition_id", using: :btree

  create_table "rulings", force: true do |t|
    t.date     "date"
    t.text     "text"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rulings", ["card_id"], name: "index_rulings_on_card_id", using: :btree

  add_foreign_key "editions", "cards", name: "editions_card_id_fk", dependent: :delete
  add_foreign_key "editions", "mtg_sets", name: "editions_mtg_set_id_fk", dependent: :delete

  add_foreign_key "printings", "editions", name: "printings_edition_id_fk", dependent: :delete

  add_foreign_key "rulings", "cards", name: "rulings_card_id_fk", dependent: :delete

end
