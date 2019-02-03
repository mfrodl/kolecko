class Solution < ApplicationRecord
  belongs_to :puzzle
  has_many :answers

  before_save do
    self.text.normalize!
  end
end
