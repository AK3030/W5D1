class User < ApplicationRecord
  validates :username, :password_digest, :session_token, presence:true
  validates :password, length: {minimum:6, allow_nil:true}
  validates :username, uniqueness: true

  after_initialize :ensure_session_token

  attr_reader :password
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)

  end

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save
    self.session_token

  end

  def ensure_session_token
    self.reset_session_token! unless self.session_token

  end


end
