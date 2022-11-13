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

ActiveRecord::Schema[7.0].define(version: 2022_11_13_232507) do
  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "album_artist"
    t.string "album"
    t.string "genre"
    t.string "kind"
    t.integer "size"
    t.integer "total_time"
    t.integer "disc_number"
    t.integer "disc_count"
    t.integer "track_number"
    t.integer "track_count"
    t.integer "year"
    t.datetime "date_modified"
    t.datetime "date_added"
    t.integer "play_count"
    t.string "play_date"
    t.string "play_date_utc"
    t.integer "rating"
    t.string "loved"
    t.string "sort_album_artist"
    t.string "sort_artist"
    t.string "persistent_id"
    t.string "location"
    t.string "sort_album"
    t.string "sort_name"
    t.string "protected"
    t.string "explicit"
    t.string "album_loved"
    t.index ["album"], name: "index_tracks_on_album"
    t.index ["album_artist"], name: "index_tracks_on_album_artist"
    t.index ["artist"], name: "index_tracks_on_artist"
    t.index ["genre"], name: "index_tracks_on_genre"
    t.index ["kind"], name: "index_tracks_on_kind"
    t.index ["name", "artist", "album", "year"], name: "index_tracks_on_name_and_artist_and_album_and_year"
    t.index ["name"], name: "index_tracks_on_name"
    t.index ["sort_album"], name: "index_tracks_on_sort_album"
    t.index ["sort_album_artist"], name: "index_tracks_on_sort_album_artist"
    t.index ["sort_artist"], name: "index_tracks_on_sort_artist"
    t.index ["sort_name"], name: "index_tracks_on_sort_name"
    t.index ["year"], name: "index_tracks_on_year"
  end

end
