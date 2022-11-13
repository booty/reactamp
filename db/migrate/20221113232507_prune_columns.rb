class PruneColumns < ActiveRecord::Migration[7.0]
  def up
    # Removing these columns speeds up query result time 2x
    remove_column :tracks, :bit_rate
    remove_column :tracks, :sample_rate
    remove_column :tracks, :skip_count
    remove_column :tracks, :skip_date
    remove_column :tracks, :album_rating
    remove_column :tracks, :album_rating_computed
    remove_column :tracks, :normalization
    remove_column :tracks, :track_type
    remove_column :tracks, :matched
    remove_column :tracks, :file_folder_count
    remove_column :tracks, :library_folder_count
    remove_column :tracks, :purchased
    remove_column :tracks, :composer
    remove_column :tracks, :artwork_count
    remove_column :tracks, :release_date
    remove_column :tracks, :comments
    remove_column :tracks, :apple_music
    remove_column :tracks, :bpm
    remove_column :tracks, :grouping
    remove_column :tracks, :compilation
    remove_column :tracks, :volume_adjustment
    remove_column :tracks, :part_of_gapless_album
    remove_column :tracks, :disliked
    remove_column :tracks, :work
    remove_column :tracks, :rating_computed
    remove_column :tracks, :clean
    remove_column :tracks, :sort_composer
    remove_column :tracks, :movement_number
    remove_column :tracks, :movement_count
    remove_column :tracks, :movement_name
    remove_column :tracks, :playlist_only
    remove_column :tracks, :has_video
    remove_column :tracks, :hd
    remove_column :tracks, :music_video
    remove_column :tracks, :stop_time
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
