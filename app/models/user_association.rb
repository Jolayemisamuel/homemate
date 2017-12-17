class UserAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :associable, polymorphic: true
end
