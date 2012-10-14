class Video < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :votes
  serialize :top_comments, Array
  default_scope order: 'created_at desc'
  validates :url, uniqueness: true

  # Returns the URL to a video in relative format.
  # eg '/videos/some-title/42'
  def comment_url
    "/videos/#{url_title}/#{id}"
  end

  # Converts title to a URL safe string.
  def url_title
    title.downcase.gsub(' ', '-').gsub(/[^A-Za-z0-9-]/, '') 
  end
end
