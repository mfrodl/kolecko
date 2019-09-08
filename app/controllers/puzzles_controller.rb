class PuzzlesController < ApplicationController
  skip_before_action :authenticate_team!

  def index
    @secondary_puzzles = Puzzle.where(puztype: 'secondary')
    @unlocked_main_puzzles = current_team.unlocked_mains.map{|m| m.puzzle}
    if current_team.solved_main_puzzles == Puzzle.where(puztype: 'main').count
      @final_puzzle = Puzzle.where(puztype: 'final').first
    end
  end

  def main
    @unlocked_main = UnlockedMain.new
  end
end
