class TeamsController < ApplicationController
  include ControllerParams

  skip_before_action :authenticate_team!, if: :skip_authenticate_team

  #def new
  #end

  #def create
  #  @team = Team.new(team_params)
  #  @team.payed = false

  #  @team.save
  #  redirect_to login_path
  #end

  def show
    @team = Team.find(params[:id])
  end

  def edit
  end

  def update
  end

  def index
    @teams = Team.all
  end

  private
    def skip_authenticate_team
      action_name == 'index' && request.format.json?
    end
end
