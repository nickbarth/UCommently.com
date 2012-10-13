require 'bundler'
Bundler.require

class SinatraApp < Sinatra::Base
  use SprockAssets

  configure do
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '../'))
    set :views, 'app/views'
  end

  get '/' do
    haml :index
  end
end
