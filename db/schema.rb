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

ActiveRecord::Schema.define(version: 20140719032139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"

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

  create_table "cc_market_prices", id: false, force: true do |t|
    t.integer  "cc_id",      null: false
    t.integer  "avg",        null: false
    t.integer  "high",       null: false
    t.integer  "low",        null: false
    t.integer  "max",        null: false
    t.integer  "median",     null: false
    t.integer  "min",        null: false
    t.integer  "stdev",      null: false
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

  create_table "mtg_set_icons", force: true do |t|
    t.integer  "mtg_set_id"
    t.string   "filename"
    t.string   "rarity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mtg_set_icons", ["filename"], name: "index_mtg_set_icons_on_filename", unique: true, using: :btree
  add_index "mtg_set_icons", ["mtg_set_id"], name: "index_mtg_set_icons_on_mtg_set_id", using: :btree

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
    t.string   "number"
    t.string   "artist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cc_id"
    t.integer  "sort_order",        default: "nextval('sort_order_seq'::regclass)", null: false
    t.integer  "other_printing_id"
  end

  add_index "printings", ["edition_id", "sort_order"], name: "index_printings_on_edition_id_and_sort_order", unique: true, using: :btree
  add_index "printings", ["other_printing_id"], name: "index_printings_on_other_printing_id", using: :btree

  create_table "product_sale_points", force: true do |t|
    t.date    "date"
    t.integer "cc_id"
    t.integer "sell_price_cents"
  end

  add_index "product_sale_points", ["cc_id"], name: "index_product_sale_points_on_cc_id", using: :btree

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

  add_foreign_key "mtg_set_icons", "mtg_sets", name: "mtg_set_icons_mtg_set_id_fk", dependent: :delete

  add_foreign_key "printings", "editions", name: "printings_edition_id_fk", dependent: :delete

  add_foreign_key "rulings", "cards", name: "rulings_card_id_fk", dependent: :delete

end
