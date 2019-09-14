class VisitsController < ApplicationController
  include ControllerParams

  def index
    @visits = Visit.where(team: current_team).sort_by(&:created_at)
  end

  def map
    @open_puzzles = Puzzle.where('? BETWEEN opens_at AND closes_at', Time.now)
    @main_puzzles = UnlockedMain.where(team: current_team).map(&:puzzle)
    @visited_puzzles = Visit.where(team: current_team).map(&:puzzle)
    @solved_puzzles = Visit.where(team: current_team)
                           .where.not(solved_at: nil)
                           .map(&:puzzle)

    if current_team.unlocked_final?
      @final_puzzles = Puzzle.where(puztype: 'final')
    else
      @final_puzzles = []
    end

    respond_to do |format|
      format.html
      format.json { render layout: false }
    end
  end

  def new
    @visit = Visit.new
  end

  def create
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = Visit.new(puzzle: @puzzle, team: current_team)
      if @visit.save
        flash[:success] = 'Příchod na stanoviště úspěšně zaznamenán'
        if @puzzle.puztype == "secondary"
          flash[:success] << ', přičteno %i OCoinů' % @puzzle.points
          current_team.points += @puzzle.points
          ot = OcoinTransaction.new(team: current_team, points: @puzzle.points,
                                    message: 'Vyzvednutí šifry %s' % @puzzle.name)
          ot.save
          current_team.save
        end
        redirect_to visits_path
      else
        flash[:alert] = 'Příchod na stanoviště byl již zaznamenán'
        redirect_to new_visit_path
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_visit_path
    end
  end
end
