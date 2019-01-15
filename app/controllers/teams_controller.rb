class TeamsController < ApplicationController
  include ControllerParams

  #def new
  #end

  #def create
  #  @team = Team.new(team_params)
  #  @team.payed = false

  #  @team.save
  #  redirect_to login_path
  #end

  def show
  end

  def edit
  end

  def update
  end

  def index
    @teams = Team.all
  end
end
