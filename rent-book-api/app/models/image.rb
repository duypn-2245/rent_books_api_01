class Image < ApplicationRecord
  belongs_to :imagetable, polymorphic: true, optional: true

  mount_uploader :photo, ImageUploader
end
