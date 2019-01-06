class Puzzle < ApplicationRecord
  has_many :answers, dependent: :destroy

  before_save do
    self.code = normalize(self.code)
    self.solution = normalize(self.solution)
  end

  def self.find_by_code(code)
    self.find_by(code: normalize(code))
  end

  private
    def self.normalize(string)
      I18n.transliterate(string).upcase
    end
end
