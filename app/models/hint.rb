class Hint < ApplicationRecord
  belongs_to :team
  belongs_to :hint_request

  validates :text, presence: true, allow_blank: false
  validates :rating, numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     allow_nil: true }
end
