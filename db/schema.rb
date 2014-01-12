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

ActiveRecord::Schema.define(version: 20131209122644) do

  create_table "dynflow_actions", primary_key: "execution_plan_uuid", force: true do |t|
    t.integer "id"
    t.text    "data"
  end

  add_index "dynflow_actions", ["execution_plan_uuid", "id"], name: "dynflow_actions_execution_plan_uuid_id_index", unique: true
  add_index "dynflow_actions", ["execution_plan_uuid", "id"], name: "sqlite_autoindex_dynflow_actions_1", unique: true
  add_index "dynflow_actions", ["execution_plan_uuid"], name: "dynflow_actions_execution_plan_uuid_index"

  create_table "dynflow_execution_plans", primary_key: "uuid", force: true do |t|
    t.text      "data"
    t.string    "state"
    t.string    "result"
    t.timestamp "started_at"
    t.timestamp "ended_at"
    t.float     "real_time"
    t.float     "execution_time"
  end

  add_index "dynflow_execution_plans", ["uuid"], name: "dynflow_execution_plans_uuid_index", unique: true
  add_index "dynflow_execution_plans", ["uuid"], name: "sqlite_autoindex_dynflow_execution_plans_1", unique: true

  create_table "dynflow_schema_info", id: false, force: true do |t|
    t.integer "version", default: 0, null: false
  end

  create_table "dynflow_steps", primary_key: "execution_plan_uuid", force: true do |t|
    t.integer   "id"
    t.integer   "action_id"
    t.text      "data"
    t.string    "state"
    t.timestamp "started_at"
    t.timestamp "ended_at"
    t.float     "real_time"
    t.float     "execution_time"
  end

  add_index "dynflow_steps", ["execution_plan_uuid", "action_id"], name: "dynflow_steps_execution_plan_uuid_action_id_index"
  add_index "dynflow_steps", ["execution_plan_uuid", "id"], name: "dynflow_steps_execution_plan_uuid_id_index", unique: true
  add_index "dynflow_steps", ["execution_plan_uuid", "id"], name: "sqlite_autoindex_dynflow_steps_1", unique: true
  add_index "dynflow_steps", ["execution_plan_uuid"], name: "dynflow_steps_execution_plan_uuid_index"

  create_table "dyntask_locks", force: true do |t|
    t.string  "task_id",       null: false
    t.string  "name",          null: false
    t.string  "resource_type"
    t.integer "resource_id"
    t.boolean "exclusive"
  end

  add_index "dyntask_locks", ["resource_type", "resource_id"], name: "index_dyntask_locks_on_resource_type_and_resource_id"

  create_table "dyntask_tasks", id: false, force: true do |t|
    t.string   "id"
    t.string   "type"
    t.string   "action"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "state",                               null: false
    t.string   "result",                              null: false
    t.decimal  "progress",    precision: 5, scale: 4
    t.string   "external_id"
  end

end
