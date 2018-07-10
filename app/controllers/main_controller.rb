class MainController < ApplicationController
  skip_before_action :authenticate_team!

  def index
  end
end
