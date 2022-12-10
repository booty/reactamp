class TracksController < ApplicationController
  MAX_RESULTS = 50

  def index
    search_string = params[:q]

    @tracks = if search_string.present?
      Track.search(search_string).map { |x| x.track }
    else
      Track.all.limit(MAX_RESULTS)
    end

    respond_to do |format|
      format.html {

      }
      format.json {
        render json: @tracks
      }
    end
  end
end
