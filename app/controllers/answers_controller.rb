class AnswersController < ApplicationController
  before_action :normalize_input, only: [:create]

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
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to new_answer_url
  end

  def normalize_input
    params[:answer][:solution] = I18n.transliterate(params[:answer][:solution])
    params[:answer][:solution].downcase!

    params[:puzzle][:code] = I18n.transliterate(params[:puzzle][:code])
    params[:puzzle][:code].downcase!
  end

  def check_solution
    @answer.correct = (@answer.solution == @puzzle.solution)

    if @answer.correct?
      flash[:success] = 'Správná odpověď'
    else
      flash[:alert] = 'Špatná odpověď'
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
