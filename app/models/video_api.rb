require 'open-uri'
# A module that fetches and parses a YouTube Video a given valid YouTube URL.
module VideoAPI
  extend self

  # Public - Returns a videos top comments.
  #
  # url - Takes a valid YouTube Video URL.
  #
  # Returns an array of hashes representing a comment object or if opening the
  # URL fails or the Top Comments section cannot be found it returns false.
  # in the form of { title: '', image: '', url: '', top_comments: {} }
  def fetch(url)
    html = open(url).read
    title = get_title(html)
    top_comments = get_comments(html)
    url = get_uri(html)
    image = get_image(url)
    { title: title, image: image, url: url, top_comments: top_comments }
  rescue
    {}
  end

  private
    # Private - Takes an HTML document and returns its title.
    def get_title(html)
      html[/<title>(.*?) -/, 1]
    end

    # Private - Takes an URI and returns its video image.
    #
    # uri - Takes a URL in the format like 'http://youtu.be/eXaMPlE'.
    def get_image(uri)
      code = uri.gsub('http://youtu.be/', '')
      "http://img.youtube.com/vi/#{code}/2.jpg"
    end

    # Private - Takes an HTML document and returns its URI.
    def get_uri(html)
      html[/<link rel="shortlink" href="(.*?)">/, 1]
    end

    # Private - Takes an HTML document and splits it into comment sections.
    #
    # Returns an array of the parsed and formatted comments.
    def get_comments(html)
      comment_text = html.gsub(/\s/, ' ')
      comment_text = comment_text[/Top Comments.*comments-section/]
      comment_sections = comment_text.split('comment yt-tile-default')
      comment_sections.map!{|section|parse_comments(section)}.compact!.sort_by!{|x|x[:thumbs]}[0..1]
    end

    # Private - Parses an HTML comment section of text.
    #
    # html - Takes a section of HTML.
    #
    # Returns a Hash in the form of { text: '', author: '', age: '', thumbs: 0 }.
    def parse_comments(html)
      thumbs = html[/data-score="(.*?)"/,1]
      return nil if thumbs.nil?
      text = html[/<p>(.*?)<\/p>/, 1]
      # this fails when the user links a time :( damn authors
      author = html[/yt-user-name.*?>(.*?)</,1]
      age = html[/<span dir=.ltr.>(.*?)<spa/,1]
      { text: text, author: author, age: age, thumbs: thumbs }
    end
end
