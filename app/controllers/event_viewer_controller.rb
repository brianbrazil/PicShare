class EventViewerController < ApplicationController
  def index
    puts "Got into index"
    #@event = Event.find(params[:id])
    #@images = @event.medias.map { |media| media.media_url }
  end
end
