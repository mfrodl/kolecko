class Hint < ApplicationRecord
  belongs_to :team
  belongs_to :hint_request

  validates :text, presence: true, allow_blank: false
end
