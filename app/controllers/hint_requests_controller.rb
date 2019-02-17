class HintRequestsController < ApplicationController
  include ControllerParams

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
      current_team.points -= hint_request_params[:bounty].to_i

      if @hint_request.save
        redirect_to hint_requests_path
      else
        flash[:alert] = @hint_request.errors.full_messages.join('<br>')
        redirect_to new_hint_request_path
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_hint_request_path
    end
  end

  def edit
  end

  def update
  end

  def cancel
    @hint_request = HintRequest.find(params[:id])
    @hint_request.cancelled = true
    if @hint_request.save
      flash[:success] = 'Úspěšně zrušeno'
    end

    redirect_to hint_requests_path
  end

  def destroy
  end
end
