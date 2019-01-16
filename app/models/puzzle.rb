class Puzzle < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :hint_requests, dependent: :destroy

  before_save do
    self.code.normalize!
    self.solution.normalize!
  end

  def self.find_by_code(code)
    self.find_by(code: code.normalize)
  end

  def full_name
    "#{number}. #{name}"
  end
end
