require 'bundler'
Bundler.require

require 'logger'
require 'open-uri'

require './db/connection'
Dir['./app/**/*.rb'].each { |file| require file }

class SinatraApp < Sinatra::Base
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

  get '/' do
    haml :index
  end

  post '/sent_comments' do
    options = VideoAPI.fetch(params[:url])
    video = Video.new(options)
    video.user_id = 1
    if video.save
      # redirect to(video.url)
      redirect to('/')
    else
      redirect back
    end
  end

  get '/videos/:title/:id' do
    # TODO video.haml
  end
end
