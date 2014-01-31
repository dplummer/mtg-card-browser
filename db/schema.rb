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

ActiveRecord::Schema.define(version: 20140131205602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "mtg_cards", force: true do |t|
    t.integer  "mtg_set_id"
    t.string   "name"
    t.string   "names",                    array: true
    t.string   "mana_cost"
    t.integer  "cmc"
    t.string   "colors",                   array: true
    t.string   "type_text"
    t.string   "supertypes",               array: true
    t.string   "card_types",               array: true
    t.string   "subtypes",                 array: true
    t.string   "rarity"
    t.text     "text"
    t.text     "flavor"
    t.string   "artist"
    t.integer  "card_number"
    t.string   "power"
    t.string   "toughness"
    t.string   "layout"
    t.integer  "multiverse_id"
    t.integer  "multiverse_variation_ids", array: true
    t.string   "mtgimage_name"
    t.string   "watermark"
    t.string   "border"
    t.integer  "vanguard_hand_modifier"
    t.integer  "vanguard_life_modifier"
    t.hstore   "rulings"
    t.hstore   "foreign_names"
    t.string   "printings",                array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_foreign_key "mtg_cards", "mtg_sets", name: "mtg_cards_mtg_set_id_fk"

end
