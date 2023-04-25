# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_23_032022) do
  create_table "forums", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "puzzle_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_forums_on_puzzle_id"
    t.index ["user_id"], name: "index_forums_on_user_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "difficulty"
    t.text "description"
    t.string "function"
    t.text "test_cases"
    t.text "expected_outputs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_puzzles_on_user_id"
  end

  create_table "user_puzzles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "puzzle_id", null: false
    t.boolean "completed"
    t.text "playback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_user_puzzles_on_puzzle_id"
    t.index ["user_id"], name: "index_user_puzzles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "forums", "puzzles"
  add_foreign_key "forums", "users"
  add_foreign_key "puzzles", "users"
  add_foreign_key "user_puzzles", "puzzles"
  add_foreign_key "user_puzzles", "users"
end
