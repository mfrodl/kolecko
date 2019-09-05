class MessagesController < ApplicationController
  def index
    current_team.team_messages do |team_message|
      team_message.read = true
    end
  end
end
