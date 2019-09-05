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

    if @visit.hint_requests.where(closed: false).any?
      flash[:alert] = 'U této šifry jste již požádali o nápovědu. ' + \
                      'Chcete-li požádat znovu, je nutné nejdříve zrušit ' + \
                      'aktivní žádosti.'
      redirect_to hint_requests_path
      return
    end

    @hint_request.visit = @visit
    @hint_request.team.points -= @hint_request.bounty

    if @hint_request.save
      flash[:success] = 'Žádost úspěšně odeslána'
      redirect_to hint_requests_path
    else
      flash[:alert] = @hint_request.errors.full_messages.join('<br>')
      redirect_to new_hint_request_path
    end
  end

  def edit
  end

  def update
  end

  def cancel
    @hint_request = HintRequest.find(params[:id])
    @hint_request.cancelled = true
    count = @hint_request.hints.count
    # If no hint was received, just return 70% of the points to the team
    if count == 0
      @hint_request.team.points += @hint_request.bounty * 7 / 10
    # else split it between all teams which sent hints
    else
      @hint_request.hints.each do |h|
        t = Team.find_by(id: h.team_id)
        t.points += @hint_request.bounty * 7 / 10 / count
        t.save
      end
    end

    if @hint_request.save
      flash[:success] = 'Úspěšně zrušeno'
    else
      flash[:alert] = @hint_request.errors.full_messages.join('<br>')
    end

    redirect_to hint_requests_path
  end

  def destroy
  end
end
