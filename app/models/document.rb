class Document < ApplicationRecord
  belongs_to :attachable, polymorphic: true
end
