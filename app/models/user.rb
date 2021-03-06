class User < ActiveRecord::Base

  has_many :portfolios
  has_secure_password

  validates :name, :email, :password, presence: true
  validates :password, confirmation: true
  
  def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!
  UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
  end
end
