# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_28_193258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "completed_exams", force: :cascade do |t|
    t.string "module"
    t.string "complete"
    t.string "allowees"
    t.string "absences"
    t.string "code_module"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "validate_date"
    t.index ["user_id"], name: "index_completed_exams_on_user_id"
  end

  create_table "next_exams", force: :cascade do |t|
    t.string "noFiche"
    t.string "choix"
    t.string "local"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "natural_date"
    t.date "date_semaine"
    t.string "examen"
    t.index ["user_id"], name: "index_next_exams_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "first_week_day"
    t.string "lundi_am"
    t.string "lundi_pm"
    t.string "mardi_am"
    t.string "mardi_pm"
    t.string "mercredi_am"
    t.string "mercredi_pm"
    t.string "jeudi_am"
    t.string "jeudi_pm"
    t.string "vendredi_am"
    t.string "vendredi_pm"
    t.string "lundi_am_module"
    t.string "lundi_pm_module"
    t.string "mardi_am_module"
    t.string "mardi_pm_module"
    t.string "mercredi_am_module"
    t.string "mercredi_pm_module"
    t.string "jeudi_am_module"
    t.string "jeudi_pm_module"
    t.string "vendredi_am_module"
    t.string "vendredi_pm_module"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.boolean "notify_week_before"
    t.boolean "notify_day_before"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "classes", default: [], array: true
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "reset_token"
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
