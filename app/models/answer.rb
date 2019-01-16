class Answer < ApplicationRecord
  belongs_to :puzzle
  belongs_to :team
  accepts_nested_attributes_for :puzzle

  before_save do
    self.correct = self.solution.normalize == self.puzzle.solution.normalize
  end
end
