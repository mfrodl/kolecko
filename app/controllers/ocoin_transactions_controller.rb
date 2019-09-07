class OcoinTransactionsController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def index
    @points = current_team.points
    ot = OcoinTransaction.where(team: current_team).sort_by(&:created_at)
    @ot = []
    sum = 0
    ot.each do |t|
      sum += t.points
      @ot << [t.created_at.strftime("%d.%m. %H:%M:%S"), t.points, sum, t.message]
    end
  end
end
