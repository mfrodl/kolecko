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
    from_team.points += hint_request.bounty * 3 / 10
    self.hint_request.closed = true
    self.hint_request.save
  end

  def accept
    self.accepted = true
    #FIXME: based on hint rating
    from_team.points += hint_request.bounty - hint_request.bounty * 3 / 10
  end

  before_save prepend: true do
    self.hint_request.closed = true if self.opened?
  end
end
