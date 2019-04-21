class Hint < ApplicationRecord
  belongs_to :from_team, foreign_key: :team_id, class_name: 'Team', autosave: true
  belongs_to :hint_request
  has_one :to_team, through: :hint_request, source: :team, autosave: true

  validates :text, presence: true, allow_blank: false
  validates :rating, numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     allow_nil: true }

  def open
    self.opened = true
    bounty_deposit = hint_request.bounty / 3
    from_team.points += bounty_deposit
    to_team.points -= bounty_deposit
  end

  def accept
    self.accepted = true
    bounty_rest = hint_request.bounty - hint_request.bounty / 3
    from_team.points += bounty_rest
    to_team.points -= bounty_rest
  end
end
