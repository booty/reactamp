# frozen_string_literal: true

class Track < ApplicationRecord
  SearchResult = Struct.new("SearchResult", :score, :track)

  def self.search(query)
    query = query.downcase

    sql_query = "%#{query}%"
    result_tracks = Track.where("name like ?", sql_query).or(
      where("artist like ?", sql_query).or(
        where("album like ?", sql_query).or(
          where("year = ?", sql_query.to_i)
        )
      ).all
    ).to_a

    order_search_results(result_tracks, query)
  end

  private

  def self.order_search_results(tracks, query)
    search_results = tracks.map do |t|
      SearchResult.new(0, t)
    end

    sort_attribs = ["name", "artist", "album", "year"]
    search_results.each do |sr|
      sort_attribs.each do |a|
        track_attribute = sr.track.attributes[a].to_s.downcase
        next unless track_attribute.include?(query)
        if track_attribute == query
          sr.score += 200
        elsif track_attribute.starts_with?(query)
          sr.score += 50
        elsif track_attribute.include?(query)
          sr.score += track_attribute.index(query)
        end
      end
    end

    search_results.sort_by do |sr|
      [
        0 - sr.score,
        sr.track.artist,
        sr.track.album,
        sr.track.track_number,
        sr.track.name
      ]
    end
  end
end