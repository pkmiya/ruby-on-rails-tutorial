class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true,
        length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: true
  # best practice:
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
