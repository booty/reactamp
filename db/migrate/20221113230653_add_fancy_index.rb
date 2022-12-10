class AddFancyIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :tracks, [:name, :artist, :album, :year]
  end
end
