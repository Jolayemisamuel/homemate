class Document < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_attached_file :file
end
