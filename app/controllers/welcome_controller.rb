class WelcomeController < ApplicationController
  def index
    @events = Event.find
  end
end
