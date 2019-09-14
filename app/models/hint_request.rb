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
  include ActionView::Helpers::UrlHelper

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

  after_create do
    message_text = "Nová žádost o nápovědu k šifře "
    message_text << link_to(puzzle.full_name,
                            Rails.application.routes.url_helpers.queue_hint_requests_path)
    message = Message.new(text: message_text)

    Visit.where(puzzle: puzzle).where.not(solved_at: nil).each do |solved_visit|
      # Hints for this puzzle sent by given team
      hints_for_puzzle_by_team = Hint.joins(:from_team, :puzzle).
                                      where(teams: { id: solved_visit.team_id },
                                            puzzles: { id: solved_visit.puzzle_id })
      # Hints for the requesting team and this puzzle sent by given team
      hints_for_visit_by_team = Hint.joins(:from_team, hint_request: :visit).
                                     where(teams: { id: solved_visit.team_id },
                                           visits: { id: visit.id },
                                           opened: true)
      if hints_for_puzzle_by_team.count < 2 && hints_for_visit_by_team.empty?
        TeamMessage.create(message: message, team: solved_visit.team)
      end
    end
  end
end
