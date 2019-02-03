class Visit < ApplicationRecord
  belongs_to :team
  belongs_to :puzzle
  has_many :answers
  has_many :solutions, through: :answers

  validates :puzzle, uniqueness: { scope: :team }

  before_save do
    total_solutions = puzzle.solutions.count
    found_solutions = solutions.count

    if found_solutions == total_solutions and total_solutions > 0
      self.solved_at = DateTime.now
    else
      self.solved_at = nil
    end
  end

  def solved?
    solved_at?
  end
end
