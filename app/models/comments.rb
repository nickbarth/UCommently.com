require 'open-uri'
# A class that fetches and parses the Top Comments section
# of a given YouTube video given its URL.
module Comments


  # Public - Returns a videos top comments.
  #
  # url - Takes a valid YouTube Video URL.
  #
  # Returns an array of hashes representing a comment object or if opening the
  # URL fails or the Top Comments section cannot be found it returns false.
  def fetch(url)
    page = open(url).read
    comment_text = page.gsub(/\s/, ' ')[/Top Comments.*Responses/]
    comment_sections = comment_text.split('comment yt-tile-default')[1..-1]
    comment_sections.map!{|section| parse(section)}
  end

  extend self

  private
    # Private - Parses an HTML comment section of text.
    #
    # html - Takes a section of HTML.
    #
    # Returns a Hash in the form of { text: '', author: '', age: '', thumbs: 0 }.
    def parse(html)
      text = html[/<p>(.*?)<\/p>/, 1]
      author = html[/<a.*?>(.*?)<\//,1]
      age = html[/<span dir=.ltr.>(.*?)<spa/,1]
      thumbs = html[/data-score="(.*?)"/,1]
      { text: text, author: author, age: age, thumbs: thumbs }
    end
end
