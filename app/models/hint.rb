class FrozenRatingValidator < ActiveModel::Validator
  def validate(record)
    if record.rating_was && record.rating != record.rating_was
      record.errors[:base] << "Nápověda už byla ohodnocena"
    end
  end
end

class Hint < ApplicationRecord
  belongs_to :from_team, foreign_key: :team_id, class_name: 'Team', autosave: true
  belongs_to :hint_request, autosave: true
  has_one :to_team, through: :hint_request, source: :team, autosave: true

  validates :text, presence: true, allow_blank: false
  validates :rating, numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     allow_nil: true }

  validates_with FrozenRatingValidator

  def open
    self.opened = true
    amount = hint_request.bounty * 3 / 10
    from_team.points += amount
    ot = OcoinTransaction.new(team: from_team, points: amount,
                              message: 'Otevřena nápověda k šifře %s' \
                              % hint_request.visit.puzzle.name)
    ot.save
    self.hint_request.closed = true
    self.hint_request.save
  end

  before_save prepend: true do
    self.hint_request.closed = true if self.opened?
  end

  after_create do
    message = Message.new(text: 'Nová nápověda')
    TeamMessage.create(message: message, team: hint_request.team)
  end
end
