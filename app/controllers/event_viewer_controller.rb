class EventViewerController < ApplicationController
  def index
    @event = Event.find params[:id]
    @images = @event.medias.map { |media| media.media_url }
    @images.shuffle!
  end
end
