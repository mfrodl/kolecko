class AnswersController < ApplicationController
  include ControllerParams

  def index
    @answers = current_team.answers
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = @puzzle.visits.find_by(team: current_team)

      if @visit
        if @visit.solved?
          flash[:alert] = 'Šifra už byla vyřešena'
          redirect_to new_answer_path
          return
        end

        @answer.visit = @visit
        @answer.solution = @puzzle.solutions.find_by(text: @answer.text.normalize)

        if @answer.save
          if @answer.correct?
            current_team.points += @answer.solution.points
            current_team.save

            total_solutions = @puzzle.solutions.count
            found_solutions = @visit.solutions.count

            flash[:success] = "Správná odpověď"
            if total_solutions > 1
              flash[:success] << " (#{found_solutions}/#{total_solutions})"
            end
          else
            flash[:alert] = 'Špatná odpověď'
            @visit.wrong_answers += 1
          end
          @visit.save
        else
          flash[:alert] = @answer.errors.full_messages.join('<br>')
        end

      else
        flash[:alert] = 'Nejprve musíte odeslat svůj příchod na stanoviště'
        redirect_to new_visit_path
        return
      end

    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to new_answer_path
  end
end
