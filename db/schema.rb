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

ActiveRecord::Schema.define(version: 20160120063738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lessons", force: :cascade do |t|
    t.integer  "schedule_id"
    t.integer  "student_id"
    t.integer  "subscription_id"
    t.integer  "lesson_status"
    t.date     "lesson_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "lessons", ["schedule_id"], name: "index_lessons_on_schedule_id", using: :btree
  add_index "lessons", ["student_id"], name: "index_lessons_on_student_id", using: :btree
  add_index "lessons", ["subscription_id"], name: "index_lessons_on_subscription_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "teacher_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "schedule_status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "schedules", ["teacher_id"], name: "index_schedules_on_teacher_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "email",                          default: "", null: false
    t.string   "encrypted_password",             default: "", null: false
    t.string   "name",               limit: 100,              null: false
    t.integer  "subscription_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_daily"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender",      limit: 2
    t.string   "nationality"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_foreign_key "lessons", "schedules"
  add_foreign_key "lessons", "students"
  add_foreign_key "lessons", "subscriptions"
  add_foreign_key "schedules", "teachers"
end
