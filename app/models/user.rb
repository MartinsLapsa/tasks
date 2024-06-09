class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  def to_s
    email
  end
end
