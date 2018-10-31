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

ActiveRecord::Schema.define(version: 20181017133641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.integer  "types"
    t.string   "location",           limit: 255
    t.text     "preview"
    t.text     "body"
    t.datetime "published_at"
    t.datetime "published_to"
    t.string   "vid_url",            limit: 255
    t.integer  "user_id",                        null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "tag"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer  "user_id",                                       null: false
    t.string   "reason",       limit: 255, default: "Blocked."
    t.datetime "blocked_at"
    t.datetime "unblocked_at"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name",     limit: 255, default: "Город"
    t.string "district", limit: 255, default: "Область"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_udx", unique: true, using: :btree
    t.index ["descendant_id"], name: "comment_desc_idx", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body",                   null: false
    t.decimal  "post_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "ancestry",   limit: 255
    t.integer  "user_id"
    t.integer  "parent_id"
    t.index ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  end

  create_table "departments", force: :cascade do |t|
    t.string "name",  limit: 255,              null: false
    t.string "desc",  limit: 255, default: ""
    t.string "phone", limit: 255, default: ""
  end

  create_table "doctor_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "doctors", force: :cascade do |t|
    t.integer  "lsd_id"
    t.integer  "organization_id"
    t.integer  "sector_id"
    t.integer  "if_user"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "active",                      default: true
    t.integer  "doctor_type_id"
    t.string   "name",            limit: 255
  end

  create_table "documents", force: :cascade do |t|
    t.string   "filename"
    t.string   "content_type"
    t.binary   "file_contents"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "files", force: :cascade do |t|
    t.string   "name",                  limit: 255, null: false
    t.text     "info"
    t.integer  "type_files_id",                     null: false
    t.datetime "taken_at",                          null: false
    t.string   "number_files",          limit: 255, null: false
    t.integer  "organization_taken_id",             null: false
    t.integer  "user_id",                           null: false
    t.string   "file",                  limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "info_desks", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.string   "contact_tel",     limit: 255, null: false
    t.string   "contact_email",   limit: 255, null: false
    t.string   "position",        limit: 255, null: false
    t.integer  "organization_id",             null: false
    t.integer  "department_id",               null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "lsd_mednets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mkb_handbooks", force: :cascade do |t|
    t.string  "code",        limit: 255, null: false
    t.string  "description", limit: 255, null: false
    t.integer "ancestry"
  end

  create_table "monitorings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "path"
    t.datetime "date"
  end

  create_table "notify_messages", force: :cascade do |t|
    t.text     "message"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "recipient_user_id"
    t.integer  "theme_id"
    t.boolean  "all"
    t.boolean  "admin"
    t.boolean  "feed"
    t.boolean  "vpch"
    t.boolean  "mse"
    t.boolean  "rmis"
    t.boolean  "frmr"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "address",              limit: 255, null: false
    t.integer  "city_id",                          null: false
    t.string   "name",                 limit: 255, null: false
    t.text     "description"
    t.string   "logo",                 limit: 255
    t.string   "tel_secretary",        limit: 255
    t.string   "fax",                  limit: 255
    t.string   "city_code",            limit: 255, null: false
    t.integer  "key"
    t.integer  "type_org_id"
    t.string   "full_name"
    t.string   "tag_ids"
    t.string   "lsd_id"
    t.string   "web_site"
    t.integer  "lsd_organization_id"
    t.boolean  "at_vpch"
    t.integer  "rhb_exc_id"
    t.boolean  "actual"
    t.integer  "frmr_organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["rhb_exc_id"], name: "index_organizations_on_rhb_exc_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.text     "body",                   null: false
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rating_answers", force: :cascade do |t|
    t.text    "body"
    t.integer "question_id"
  end

  create_table "rating_people_answers", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "type_id"
    t.integer "question_id"
    t.integer "answer_id"
    t.integer "sum"
    t.boolean "is_electron"
  end

  create_table "rating_questions", force: :cascade do |t|
    t.text    "body"
    t.integer "type_id"
  end

  create_table "rating_results", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.integer  "type_id"
    t.integer  "sum"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "redactor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sector_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "organization_id"
    t.integer  "sector_type_id"
    t.boolean  "old"
    t.integer  "lsd_sector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "type_files", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "type_organizations", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                      limit: 255, default: "",    null: false
    t.string   "encrypted_password",                         limit: 255, default: "",    null: false
    t.string   "reset_password_token",                       limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                         limit: 255
    t.string   "last_sign_in_ip",                            limit: 255
    t.string   "username",                                   limit: 255
    t.boolean  "admin",                                                  default: false
    t.boolean  "moderator",                                              default: false
    t.boolean  "mz",                                                     default: false
    t.string   "fio",                                        limit: 255
    t.string   "hospital",                                   limit: 255
    t.boolean  "blocks",                                                 default: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.string   "ancestry",                                   limit: 255
    t.boolean  "onko",                                                   default: false
    t.boolean  "spid",                                                   default: false
    t.integer  "role_id",                                                default: 4
    t.string   "phone",                                      limit: 255
    t.boolean  "feed"
    t.boolean  "vpch"
    t.boolean  "mse"
    t.string   "confirmation_token",                         limit: 255
    t.string   "unconfirmed_email",                          limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "organization_id"
    t.boolean  "rmis"
    t.boolean  "consent_to_the_processing_of_personal_data"
    t.boolean  "frmr",                                                   default: false
    t.index ["ancestry"], name: "index_users_on_ancestry", using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
