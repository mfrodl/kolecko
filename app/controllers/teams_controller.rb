class TeamsController < ApplicationController
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

  private
    def team_params
      params.require(:team).permit(
        :name, :phone, :password, :player1_name, :player1_email,
        :player2_name, :player2_email, :player3_name, :player3_email,
        :player4_name, :player4_name
      )
    end
end
