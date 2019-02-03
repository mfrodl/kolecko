class Visit < ApplicationRecord
  belongs_to :team
  belongs_to :puzzle
  has_many :answers
  has_many :solutions, through: :answers

  validates :puzzle, uniqueness: { scope: :team }

  def solved?
    solved_at?
  end
end
