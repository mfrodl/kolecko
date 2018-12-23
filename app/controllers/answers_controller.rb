class AnswersController < ApplicationController
  def index
    # TODO: Filter only answers for logged in team
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @puzzle = Puzzle.find_by(puzzle_params)

    if @puzzle
      @answer.puzzle = @puzzle
      if @answer.save
        check_solution
      else
        flash[:alert] = @answer.errors
        redirect_to new_answer_url
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_answer_url
    end
  end

  def check_solution
    @answer.correct = (@answer.solution == @puzzle.solution)

    if @answer.correct?
      flash[:success] = 'Správná odpověď'
      redirect_to new_answer_url
    else
      flash[:alert] = 'Špatná odpověď'
      redirect_to new_answer_url
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:solution)
    end

    def puzzle_params
      params.require(:puzzle).permit(:code)
    end
end
