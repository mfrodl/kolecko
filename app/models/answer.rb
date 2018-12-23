class Answer < ApplicationRecord
  belongs_to :puzzle
  accepts_nested_attributes_for :puzzle
end
