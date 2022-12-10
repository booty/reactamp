class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :name, index: true
      t.string :artist, index: true
      t.string :album_artist, index: true
      t.string :album, index: true
      t.string :genre, index: true
      t.string :kind, index: true
      t.integer :size
      t.integer :total_time
      t.integer :disc_number
      t.integer :disc_count
      t.integer :track_number
      t.integer :track_count
      t.integer :year, index: true
      t.datetime :date_modified
      t.datetime :date_added
      t.integer :bit_rate
      t.integer :sample_rate
      t.integer :play_count
      t.string :play_date
      t.string :play_date_utc
      t.integer :skip_count
      t.datetime :skip_date
      t.integer :rating
      t.integer :album_rating
      t.string :album_rating_computed
      t.string :loved
      t.integer :normalization
      t.string :sort_album_artist, index: true
      t.string :sort_artist, index: true
      t.string :persistent_id
      t.string :track_type
      t.string :matched
      t.string :location
      t.integer :file_folder_count
      t.integer :library_folder_count
      t.string :purchased
      t.string :composer
      t.integer :artwork_count
      t.datetime :release_date
      t.string :comments
      t.string :sort_album, index: true
      t.string :sort_name, index: true
      t.string :protected
      t.string :apple_music
      t.integer :bpm
      t.string :grouping
      t.string :compilation
      t.integer :volume_adjustment
      t.string :part_of_gapless_album
      t.string :disliked
      t.string :work
      t.string :rating_computed
      t.string :clean
      t.string :sort_composer
      t.string :explicit
      t.string :album_loved
      t.integer :movement_number
      t.integer :movement_count
      t.string :movement_name
      t.string :playlist_only
      t.string :has_video
      t.string :hd
      t.string :music_video
      t.string :stop_time
    end
  end
end
