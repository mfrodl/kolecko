class Answer < ApplicationRecord
  belongs_to :puzzle
  belongs_to :team
  accepts_nested_attributes_for :puzzle
end
