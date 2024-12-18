class User < ApplicationRecord
  has_secure_password  
  has_many :bookings
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  def admin?
    self.is_admin
  end
end
