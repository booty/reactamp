# frozen_string_literal: true

class TracksController < ApplicationController
  def index
    query = params[:query]
    @tracks = if params[:query]
      Track.search(query)
    else
      Track.
        order(:artist, :album, :track_number, :name).
        first(200)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @tracks }
      format.json { render json: @tracks }
    end
  end
end
