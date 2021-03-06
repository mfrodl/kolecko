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
      #FIXME: I want the last hint_request, will this work? Are they ordered chronologically?
      @hint_request = @visit.hint_requests.last

      if @visit
        if @visit.solved?
          flash[:alert] = 'Šifra už byla vyřešena'
          redirect_to new_answer_path
          return
        end

        #Check here for pending hint request rating
        if @hint_request
          if @hint_request.closed == false
            if @hint_request.hints.where(opened: true).count > 0
              flash[:alert] = 'Před odesláním odpovědi je třeba ohodnotit nápovědu.'
              redirect_to queue_hint_requests_path
            end
          end
        end

        @answer.visit = @visit
        @answer.solution = @puzzle.solutions.find_by(text: @answer.text.normalize)

        if @answer.save
          if @answer.correct?

            # Check for pending hint_request and cancel
            if @hint_request
              if @hint_request.closed == false

                @hint_request.cancelled = true
                count = @hint_request.hints.count
                # If no hint was received, just return 70% of the points to the team
                if count == 0 && @hint_request.visit.dead == false && @hint_request.visit.orghint == false
                  amount = @hint_request.bounty * 7 / 10
                  current_team.points += amount
                  ot = OcoinTransaction.new(team: current_team, points: amount,
                       message: 'Vrácená část bodů za nevyužitou nápovědu k šifře %s' % @hint_request.visit.puzzle.name)
                  ot.save

                # else split it between all teams which sent hints
                else
                  @hint_request.hints.each do |h|
                    t = Team.find_by(id: h.team_id)
                    amount = @hint_request.bounty * 7 / 10 / count
                    t.points += amount
                    ot = OcoinTransaction.new(team: t, points: amount,
                                  message: 'Odměna za nápovědu k %s' \
                                  % @hint_request.visit.puzzle.name)
                    ot.save
                    t.save
                  end
                end
                @hint_request.save
              end
            end

            if @puzzle.puztype == 'main'
              current_team.solved_main_puzzles += 1
            elsif @puzzle.puztype == 'final'
              current_team.solved_final_puzzle = true
            elsif @puzzle.puztype == 'secondary'
              current_team.points += @answer.solution.points
              ot = OcoinTransaction.new(team: current_team, points: @answer.solution.points,
                                       message: 'Řešení šifry %s' % @puzzle.name)
              ot.save
            end
            current_team.save

            total_solutions = @puzzle.solutions.count
            found_solutions = @visit.solutions.count

            flash[:success] = "Správná odpověď"
            if total_solutions > 1
              flash[:success] << " (#{found_solutions}/#{total_solutions})"
            end

            if @puzzle.puztype == 'secondary'
              flash[:success] << ", přičteno %i OCoinů" % @answer.solution.points
            elsif @puzzle.puztype == 'final'
              flash[:success] << ", úspěšně jste vyřešili cílovou šifru"
            elsif @puzzle.puztype == 'main'
              num = Puzzle.where(puztype: 'main').count
              text = ", vyřešena %i. hlavní šifra ze %i" % [current_team.solved_main_puzzles, num]
              flash[:success] << text
              if current_team.solved_main_puzzles == num
                flash[:success] << ", byla odkryta poloha cíle"
              end
            end

          else
            # Substract points here if too many bad answers
            # With the exception of puzzles which have more answers
            @visit.wrong_answers += 1
            if @visit.wrong_answers == 3 && @puzzle.solutions.count == 1
              flash[:alert] = 'Třetí špatná odpověď, za každou další špatnou odpověď bude strhnuto 5 OCoinů.'
            elsif @visit.wrong_answers > 3 && @puzzle.solutions.count == 1
              flash[:alert] = 'Špatná odpověď, odečteno 5 OCoinů.'
              current_team.points -= 5
              current_team.save
              ot = OcoinTransaction.new(team: current_team, points: -5,
                                        message: 'Opakovaná špatná odpověď k šifře %s' % @puzzle.name)
              ot.save
            else
              flash[:alert] = 'Špatná odpověď'
            end
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
