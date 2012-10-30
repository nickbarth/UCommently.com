class User < ActiveRecord::Base
  has_many :videos

  # Finds or creates a user by their Facebook Id.
  def self.fetch_user(facebook_user)
    User.find_or_create_by_facebook_id   facebook_user.id,
                           name:         facebook_user.name,
                           image:        facebook_user.thumbnail,
                           access_token: facebook_user.access_token
  end
end
