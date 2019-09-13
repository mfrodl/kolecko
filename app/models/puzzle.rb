require 'geo/coord'

class Puzzle < ApplicationRecord
  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper

  has_many :visits, dependent: :destroy
  has_many :hint_requests, dependent: :destroy
  has_many :solutions, dependent: :destroy
  has_many :answers, through: :visits, dependent: :destroy

  enum puztype: [:main, :secondary, :final]

  validates :solutions, presence: true
  validates :puztype, presence: true

  before_save do
    self.code.normalize!
  end

  def self.find_by_code(code)
    self.find_by(code: code.normalize)
  end

  def full_name
    name
  end

  def self.notify_opened
    newly_opened_puzzles = Puzzle.where(puztype: 'secondary', opened: false).
                                  where('opens_at <= ?', DateTime.now)
    newly_opened_puzzles.each do |puzzle|
      message_text = "Byla otevřena nová vedlejší šifra na souřadnicích "
      message_text << link_to(Geo::Coord.new(puzzle.latitude, puzzle.longitude).to_s,
                              Rails.application.routes.url_helpers.map_path)
      message = Message.new(text: message_text)

      if message.save and message.create_team_messages
        puzzle.update(opened: true)
      end
    end
  end
end
