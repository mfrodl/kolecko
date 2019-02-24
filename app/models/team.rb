class Team < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :visits, dependent: :destroy
  has_many :answers, through: :visits
  has_many :hint_requests, through: :visits
  has_many :received_hints, through: :hint_requests, source: :hints

  validates :name, presence: true, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
