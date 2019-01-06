class HintsController < ApplicationController
  def index
  end

  def queue
  end

  def new
    @hint = Hint.new
  end

  def create
    @hint = Hint.new(hint_params)
    @hint.team = current_team

    if @hint.save
      flash[:success] = 'Nápověda odeslána'
      redirect_to queue_hint_requests_path
    else
      flash[:alert] = @hint.errors.full_messages.join('<br>')
      redirect_to answer_hint_request_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def hint_params
      params.require(:hint).permit(:text, :hint_request_id)
    end
end
