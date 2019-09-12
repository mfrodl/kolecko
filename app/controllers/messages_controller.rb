class MessagesController < ApplicationController
  include ControllerParams

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save && @message.create_team_messages
      flash[:success] = "Zpráva byla úspěšně odeslána"
    else
      flash[:alert] = "Nepodařilo se odeslat zprávu"
    end

    redirect_to new_message_path
  end

  def edit
  end

  def update
  end

  def index
    current_team.team_messages.each do |team_message|
      team_message.read = true
      team_message.save!
    end
  end
end
