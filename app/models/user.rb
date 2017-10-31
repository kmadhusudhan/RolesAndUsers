class User < ApplicationRecord
	has_and_belongs_to_many :roles
	validates :email, uniqueness: true
	has_attached_file :photo, styles: { thumb: ["64x64#", :jpg] }
	validates_attachment :photo, presence: true,
		content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
		size: { in: 0..500.kilobytes }
end
