class VisitsController < ApplicationController
  include ControllerParams

  def index
    @visits = Visit.where(team: current_team).sort_by {|visit| visit.puzzle.number}
  end

  def new
    @visit = Visit.new
  end

  def create
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = Visit.new
      @visit.puzzle = @puzzle
      @visit.team = current_team
      @visit.save
      redirect_to visits_path
    else
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_visit_path
    end
  end
end
