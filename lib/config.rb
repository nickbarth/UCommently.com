require 'bundler'
Bundler.require

require 'logger'
require 'open-uri'
require './db/connection'

Dir['./app/**/*.rb'].each { |file| require file }
Dir['./lib/extensions/*.rb'].each { |file| require file }

class SinatraApp < Sinatra::Base
  before { ActiveRecord::Base.verify_active_connections! }
  after  { ActiveRecord::Base.clear_active_connections! }

  configure :development do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  configure do
    enable :sessions
    use Rack::Flash
    use SprockAssets
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '../'))
    set :views, 'app/views'
    GraphAPI.config do
      app_secret   APP_SECRET
      client_id    CLIENT_ID
      callback_url 'http://ucommently.com/facebook_callback'
      logout_url   'http://ucommently.com/'
      access_scope [:offline_access]
      user_fields  [:id, :picture, :name]
    end
  end
end
