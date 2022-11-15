# frozen_string_literal: true

class Api::V1::TracksController < ApplicationController
  def index
    query = params[:query]
    @tracks = if params[:query]
      Track.search(query).first(200)
    else
      Track.
        order(:artist, :album, :track_number, :name).
        first(200)
    end

    respond_to do |format|
      format.json { render json: @tracks }
    end
  end
end
