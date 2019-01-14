class HintRequest < ApplicationRecord
  belongs_to :team
  belongs_to :puzzle
  has_many :hints, dependent: :destroy
end
