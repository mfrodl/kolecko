class Team < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable

  has_many :visits, dependent: :destroy
  has_many :answers, through: :visits
  has_many :hint_requests, through: :visits
  has_many :received_hints, through: :hint_requests, source: :hints
  has_many :sent_hints, class_name: 'Hint'

  validates :name, presence: true, uniqueness: true
  validates_presence_of :password, :player1_name, :player1_email
  validates_confirmation_of :password, message: 'se musí shodovat'
  validates :phone, format: {
    with: /\A[0-9]{9}\z/,
    message: 'je v neplatném formátu'
  }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def hint_quality
    # Average rating of hints sent by the team that have a rating. If no rated
    # hint exists yet, default to 3 stars.
    '%.1f' % sent_hints.average(:rating) || 3.0
  end
end
