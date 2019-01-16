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

ActiveRecord::Schema.define(version: 20190113131307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "solution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "correct"
    t.bigint "puzzle_id"
    t.bigint "team_id"
    t.index ["puzzle_id"], name: "index_answers_on_puzzle_id"
    t.index ["team_id"], name: "index_answers_on_team_id"
  end

  create_table "hint_requests", force: :cascade do |t|
    t.bigint "team_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "puzzle_id"
    t.index ["puzzle_id"], name: "index_hint_requests_on_puzzle_id"
    t.index ["team_id"], name: "index_hint_requests_on_team_id"
  end

  create_table "hints", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "hint_request_id"
    t.string "text"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hint_request_id"], name: "index_hints_on_hint_request_id"
    t.index ["team_id"], name: "index_hints_on_team_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "solution"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "phone"
    t.boolean "payed"
    t.string "player1_name"
    t.string "player1_email"
    t.string "player2_name"
    t.string "player2_email"
    t.string "player3_name"
    t.string "player3_email"
    t.string "player4_name"
    t.string "player4_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["reset_password_token"], name: "index_teams_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "puzzle_id"
    t.integer "wrong_answers", default: 0
    t.datetime "solved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_visits_on_puzzle_id"
    t.index ["team_id"], name: "index_visits_on_team_id"
  end

  add_foreign_key "answers", "puzzles"
  add_foreign_key "answers", "teams"
  add_foreign_key "hint_requests", "puzzles"
  add_foreign_key "hint_requests", "teams"
  add_foreign_key "visits", "puzzles"
  add_foreign_key "visits", "teams"
end
