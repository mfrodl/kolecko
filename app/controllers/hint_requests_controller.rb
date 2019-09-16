class HintRequestsController < ApplicationController
  include ControllerParams

  def index
    @hint_requests = HintRequest.joins(:visit).
                                 where(visits: { team: current_team })
  end

  def dead
    p = Puzzle.find_by_code(puzzle_params[:code])
    v = Visit.find_by(puzzle: p, team: current_team)
    if v.dead || v.solved_at
      flash[:alert] = "Tuto šifru jste již deadovali nebo vyřešili"
    else
      # FIXME: do we want to mark it solved directly or
      # just show the solution and let the teams still do it 
      v.dead = true
      v.save
      flash[:success] = "Dead zaznamenán, nyní můžete zavolat orgům o princip řešení"
    end

    redirect_to new_hint_request_path
  end

  def request_org_hint
    p = Puzzle.find_by_code(puzzle_params[:code])
    v = Visit.find_by(puzzle: p, team: current_team)
    if v.orghint
      flash[:alert] = "Již jste žádali dříve o nápovědu od orgů."
    else
      # FIXME: do we want to mark it solved directly or
      # just show the solution and let the teams still do it
      # in other words should this create a solution automatically?
      v.orghint = true
      v.save
      flash[:success] = "Zaznamenáno, nyní můžete zavolat orgům o nápovědu"
    end
    
    redirect_to new_hint_request_path
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
    @possible_org_hint = []
    @possible_dead = []
    unsolved_visits.each do |v|
      if v.puzzle.solutions.count == 1
        @unsolved_puzzles << [v.puzzle.full_name, v.puzzle.code]
      end
      if v.puzzle.puztype == 'main' || v.puzzle.puztype == 'final'
        spent = 0
        v.hint_requests.each do |h|
          spent += h.bounty
        end
        if spent >= 30 && Time.now - v.created_at > 3600 && v.orghint == false
          @possible_org_hint << [v.puzzle.full_name, v.puzzle.code]
        end
        if spent >= 50 && Time.now - v.created_at > 7200 && v.dead == false
          @possible_dead << [v.puzzle.full_name, v.puzzle.code]
        end
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
