class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  has_attached_file :photo, :use_timestamp => false,
      :url => "/uploads/:class/:id/:filename",
      :path => ":rails_root/public/uploads/:class/:id/:filename"
        validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
  def self.from_yourself(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id = :user_id", 
          user_id: user.id)

  end
end
