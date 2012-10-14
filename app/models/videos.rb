class Video < ActiveRecord::Base
  belongs_to :user

  serialize :top_comments, Array
end
