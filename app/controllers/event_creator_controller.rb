class EventCreatorController < ApplicationController
  def index
    @event = Event.new
  end

  def create
  end
end
