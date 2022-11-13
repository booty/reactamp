class AddFancyIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :tracks, [:name, :artist, :album, :year]
  end
end
