require 'bundler'
Bundler.require

require 'logger'

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

  post '/add_video' do


  end
end
