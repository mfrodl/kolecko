class Puzzle < ApplicationRecord
  has_many :answers, dependent: :destroy
  before_save :normalize

  private
    def normalize
      self.code = I18n.transliterate(self.code).upcase
      self.solution = I18n.transliterate(self.solution).upcase
    end
end
