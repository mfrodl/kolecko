class AnswersController < ApplicationController
  include ControllerParams

  def index
    @answers = Answer.where(team: current_team)
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = Visit.find_by(team: current_team, puzzle: @puzzle)

      if @visit
        @answer.puzzle = @puzzle
        @answer.team = current_team

        if @answer.save
          if @answer.correct?
            flash[:success] = 'Správná odpověď'
            @visit.solved_at = DateTime.now
          else
            flash[:alert] = 'Špatná odpověď'
            @visit.wrong_answers += 1
          end
        else
          flash[:alert] = @answer.errors.full_messages.join('<br>')
        end

      else
        flash.alert = 'Nejprve musíte odeslat svůj příchod na stanoviště'
        redirect_to new_visit_path
        return
      end

    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to new_answer_path
  end
end
