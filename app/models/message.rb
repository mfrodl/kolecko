class Message < ApplicationRecord
  has_many :team_messages

  def create_team_messages
    Team.all.each do |team|
      TeamMessage.create(team: team, message: self)
    end
  end
end
