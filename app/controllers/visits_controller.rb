class VisitsController < ApplicationController
  include ControllerParams

  def index
    @visits = Visit.where(team: current_team).sort_by {|visit| visit.puzzle.number}
  end

  def map
    @open_puzzles = Puzzle.where('? BETWEEN opens_at AND closes_at', Time.now)
    @visited_puzzles = Visit.where(team: current_team).map(&:puzzle)
    @solved_puzzles = Visit.where(team: current_team)
                           .where.not(solved_at: nil)
                           .map(&:puzzle)
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
