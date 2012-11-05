class Video < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :votes
  serialize :top_comments, Array
  validates :url, uniqueness: true
  validates_presence_of :title

  # Returns the URL to a video in relative format.
  # eg '/videos/some-title/42'
  def comment_url
    "/videos/#{url_title}/#{id}"
  end

  # Converts title to a URL safe string.
  def url_title
    title.downcase.gsub(' ', '-').gsub(/[^A-Za-z0-9-]/, '') 
  end

  # Create a new vote and record the updated score.
  #
  # Returns true if the vote was successful.
  def record_vote(request_ip, rating)
    vote = self.votes.find_or_create_by_user_ip(request_ip)
    # Remove original score
    self.score -= vote.score
    self.user.score -= vote.score
    # Calculate new score
    vote.set_score(rating)
    # Update video score
    self.score += vote.score
    self.user.score += vote.score
    # Return true if vote was successful
    return (vote.score != 0 and vote.save and self.save and self.user.save)
  end
end
