class HintRequestsController < ApplicationController
  def index
    @hint_requests = HintRequest.where(team: current_team)
  end

  def queue
    @hint_requests = HintRequest.where.not(team: current_team)
  end

  def new
    @hint_request = HintRequest.new
  end

  def create
    @hint_request = HintRequest.new(hint_request_params)
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @hint_request.puzzle = @puzzle
      @hint_request.team = current_team

      if not @hint_request.save
        flash[:alert] = @hint_request.errors.full_messages.join('<br>')
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to hint_requests_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def hint_request_params
      params.require(:hint_request).permit(:note)
    end

    def puzzle_params
      params.require(:puzzle).permit(:code)
    end
end
