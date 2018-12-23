class Puzzle < ApplicationRecord
  has_many :answers, dependent: :destroy
end
