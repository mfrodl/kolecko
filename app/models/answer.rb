class Answer < ApplicationRecord
  belongs_to :visit
  belongs_to :solution, optional: true
  has_one :team, through: :visit
  has_one :puzzle, through: :visit

  validates :solution, uniqueness: { scope: :visit,
                                     allow_blank: true,
                                     message: 'již odesláno' }

  accepts_nested_attributes_for :puzzle

  def correct?
    !solution_id.nil?
  end
end
