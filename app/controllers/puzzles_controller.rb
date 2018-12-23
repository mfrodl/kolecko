class PuzzlesController < ApplicationController
  skip_before_action :authenticate_team!

  def index
    @puzzles = Puzzle.all
  end
end
