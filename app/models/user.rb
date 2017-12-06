class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable, :timeoutable, :validatable
end
