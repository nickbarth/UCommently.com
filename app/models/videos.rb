class Video < ActiveRecord::Base
  belongs_to :user
  serialize :top_comments, Array
  default_scope order: 'created_at desc'

  # Returns the URL to a video in relative format.
  # eg '/videos/some-title/42'
  def comment_url
    url_title = title.downcase.gsub(' ', '-').gsub(/[^A-Za-z0-9-]/, '') 
    "/videos/#{url_title}/#{id}"
  end
end
