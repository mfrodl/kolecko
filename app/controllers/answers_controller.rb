class AnswersController < ApplicationController
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
      @answer.puzzle = @puzzle
      @answer.team = current_team

      if @answer.save
        check_solution
      else
        flash[:alert] = @answer.errors.full_messages.join('<br>')
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to new_answer_path
  end

  private
    def answer_params
      params.require(:answer).permit(:solution)
    end

    def puzzle_params
      params.require(:puzzle).permit(:code)
    end

    def check_solution
      @answer.correct =
        @answer.solution.normalize == @puzzle.solution.normalize

      if @answer.correct?
        flash[:success] = 'Správná odpověď'
      else
        flash[:alert] = 'Špatná odpověď'
      end
    end
end
