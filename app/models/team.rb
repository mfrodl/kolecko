class Team < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :visits, dependent: :destroy
  has_many :answers, through: :visits

  validates :name, presence: true, uniqueness: true

  def balance
    points - deposit
  end

  def balance_was
    points_was - deposit_was
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
