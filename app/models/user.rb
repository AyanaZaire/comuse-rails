class User < ApplicationRecord

has_secure_password

# def authenticate(password)

validates :name, :bio, :email, :image_url, presence: true
validates :email, uniqueness: true

end
