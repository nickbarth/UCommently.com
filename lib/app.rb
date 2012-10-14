require 'bundler'
Bundler.require

require 'logger'
require 'open-uri'

require './db/connection'
Dir['./app/**/*.rb'].each { |file| require file }

class SinatraApp < Sinatra::Base
  enable :sessions
  use Rack::Flash
  before { ActiveRecord::Base.verify_active_connections! }
  after  { ActiveRecord::Base.clear_active_connections! }

  configure :development do
    use SprockAssets
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  configure do
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '../'))
    set :views, 'app/views'
  end

  helpers do
    # Returns the current user if non are logged in it will return an anonymouse
    # user for use with submitting videos.
    def current_user
      @current_user ||= User.find(session[:user_id] || 1)
    end

    # Returns all videos ordered by their created_at dates.
    def videos
      @videos ||= Video.all
    end
  end

  get '/' do
    haml :index
  end

  # Adds the users submitted video to the database or errors out on invalid or
  # duplicate video submissions.
  post '/send_comments' do
    options = VideoAPI.fetch(params[:url])
    video = Video.new(options)
    video.user_id = 1
    if video.save
      # redirect to(video.url)
      flash[:notice] = 'Your video was successfully sent! :)'
      redirect to('/')
    else
      flash[:notice] = 'The video you sent was invalid or did not any have top comments. :('
      redirect back
    end
  end

  get '/send_vote/:vote/:title/:video_id' do
    video = Video.find(params[:video_id])
    vote = video.votes.find_or_create_by_user_ip(request.ip)
    # Remove original score
    video.score -= vote.score
    # Calculate new score
    vote.set_score(params[:vote])
    # Update video score
    video.score += vote.score

    if vote.score != 0 and vote.save and video.save
      flash[:notice] = 'Your vote was successful. :)'
    else
      flash[:notice] = 'Your vote was invalid. :('
    end

    redirect back
  end

  get '/videos/:title/:id' do
    # TODO video.haml
  end
end
