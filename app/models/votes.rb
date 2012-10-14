class Vote < ActiveRecord::Base
  belongs_to :video

  # Sets the score of the current vote based on valid input.
  def set_score(vote)
    self.score = 1 if vote == 'up'
    self.score = -1 if vote == 'down'
  end
end
