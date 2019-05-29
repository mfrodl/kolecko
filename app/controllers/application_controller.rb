class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :authenticate_team!

  def signed_in_root_path(resource)
    team_path(current_team)
  end
end
