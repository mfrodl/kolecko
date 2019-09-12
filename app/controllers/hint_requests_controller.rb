class HintRequestsController < ApplicationController
  include ControllerParams

  def index
    @hint_requests = HintRequest.joins(:visit).
                                 where(visits: { team: current_team })
  end

  def queue
   @hint_requests = HintRequest.joins(:visit).
                                where.not(visits: { team: current_team },
                                          cancelled: true)
   @hints_from_me = Hint.where(team_id: current_team.id)
  end

  def new
    @hint_request = HintRequest.new
    unsolved_visits = current_team.visits.where(solved_at: [nil])
    @unsolved_puzzles = []
    unsolved_visits.each do |v|
      if v.puzzle.solutions.count == 1
        @unsolved_puzzles << [v.puzzle.full_name, v.puzzle.code]
      end
    end
  end

  def create
    @hint_request = HintRequest.new(hint_request_params)
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if !@puzzle
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_hint_request_path
      return
    end

    @visit = Visit.find_by(team: current_team, puzzle: @puzzle)
    if !@visit
      flash[:alert] = 'Nejprve musíte odeslat svůj příchod na stanoviště'
      redirect_to new_visit_path
      return
    end

    @hint_request.visit = @visit

    if @hint_request.save
      flash[:success] = 'Žádost úspěšně odeslána'
      ot = OcoinTransaction.new(team: current_team, points: -@hint_request.bounty,
                                message: 'Žádost o nápovědu pro šifru %s' % @visit.puzzle.name)
      ot.save
      redirect_to hint_requests_path
    else
      flash[:alert] = @hint_request.errors.full_messages.join('<br>')
      redirect_to new_hint_request_path
    end
  end

  def edit
    @hint_request = HintRequest.find(params[:id])
    if @hint_request.team != current_team
      flash[:alert] = 'Nemáte právo k úpravě této nápovědy'
      redirect_to hint_requests_path
    end
  end

  def update
    @hint_request = HintRequest.find(params[:id])
    if @hint_request.team != current_team
      flash[:alert] = 'Nemáte právo k úpravě této nápovědy'
    else
      @hint_request.bounty = hint_request_params[:bounty]

      if @hint_request.save
        increase = hint_request_params[:bounty].to_f - @hint_request.bounty
        ot = OcoinTransaction.new(team: current_team, points: -increase,
                                  message: 'Navýšení žádosti o nápovědu pro šifru %s' \
                                  % @hint_request.visit.puzzle.name)
        ot.save
        flash[:success] = 'Odměna úspěsně navýšena'
      else
         flash[:alert] = 'K provedení akce nemáte dost OCoinů'
      end
    end
    redirect_to hint_requests_path
  end

  def cancel
  end

  def destroy
  end
end
