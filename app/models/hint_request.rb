class CancelValidator < ActiveModel::Validator
  def validate(record)
    has_opened_hints = record.hints.where(opened: true).exists?
    if record.cancelled_changed? && record.cancelled && has_opened_hints
      message = "Tuto žádost o nápovědu už není možné zrušit"
      record.errors.add(:base, message)
    end
  end
end

class HintRequest < ApplicationRecord
  belongs_to :visit
  has_one :team, through: :visit, autosave: true
  has_one :puzzle, through: :visit
  has_many :hints, dependent: :destroy

  validates :bounty, presence: true
  validates_with CancelValidator

  before_validation do
    team.points -= bounty - bounty_was
  end

# this is probably something I don't want
#  before_save do
#    self.closed = true if self.cancelled?
#  end

end
