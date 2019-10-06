class Visit < ApplicationRecord
  belongs_to :team
  belongs_to :puzzle
  has_many :answers, dependent: :destroy
  has_many :hint_requests
  has_many :solutions, through: :answers
  has_many :hints, through: :hint_requests

  validates :puzzle, uniqueness: { scope: :team }
  validates_with TimeValidator

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
