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

ActiveRecord::Schema[8.0].define(version: 2025_02_28_085432) do
  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pets", force: :cascade do |t|
    t.integer "pet_id"
    t.string "name"
    t.string "animal_type"
    t.string "breed"
    t.string "age"
    t.string "size"
    t.string "gender"
    t.string "status"
    t.text "photo_urls"
    t.integer "shelter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shelter_id"], name: "index_pets_on_shelter_id"
  end

  create_table "pets_tags", force: :cascade do |t|
    t.integer "pet_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_pets_tags_on_pet_id"
    t.index ["tag_id"], name: "index_pets_tags_on_tag_id"
  end

  create_table "shelters", force: :cascade do |t|
    t.string "shelter_id"
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "distance"
    t.integer "category_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pets", "shelters"
  add_foreign_key "pets_tags", "pets"
  add_foreign_key "pets_tags", "tags"
end
