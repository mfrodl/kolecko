class Team < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :visits, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  #HUMANIZED_COLUMNS = {:name => "Název týmu"}

  #def human_attribute_name(attribute)
  #  'Název týmu'
  #  #HUMANIZED_COLUMNS[attribute.to_sym] || super
  #end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
