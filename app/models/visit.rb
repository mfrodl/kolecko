class Visit < ApplicationRecord
  belongs_to :team
  belongs_to :puzzle

  validates :puzzle, uniqueness: { scope: :team }
end
