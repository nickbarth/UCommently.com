require './lib/config'

class SinatraApp
  helpers do
    # Returns the current user if non are logged in it will return an anonymouse
    # user for use with submitting videos.
    def current_user
      @current_user ||= User.find(session[:user_id] || 1)
    end

    # Returns all videos ordered by their created_at dates.
    def videos
      @videos ||= Video.includes(:user).order('created_at desc')
    end

    # Checks main navigation for current page
    def current_page?(page, homepage=false)
      return request.path_info != '/about' ? 'selected' : nil if homepage
      request.path_info == page ? 'selected' : nil
    end
  end

  # Home Page
  get '/' do
    haml :index
  end

  # Sort videos by best score
  get '/popular' do
    @videos = Video.includes(:user).order('score desc')
    haml :index
  end

  # Sort videos by worst score
  get '/worst' do
    @videos = Video.includes(:user).order('score asc')
    haml :index
  end

  # About Page
  get '/about' do
    haml :about
  end

  # Adds the users submitted video to the database or errors out on invalid or
  # duplicate video submissions.
  post '/send_comments' do
    options = YouTubeAPI.fetch(params[:url])
    video = Video.new(options)
    video.user = current_user
    if video.save
      flash[:notice] = 'Your video was successfully sent! :)'
      redirect to('/')
    else
      flash[:notice] = 'The video you sent was invalid or did not any have top comments. :('
      redirect back
    end
  end

  # Records a vote for a particular video.
  get '/send_vote/:vote/:title/:video_id' do
    video = Video.find(params[:video_id])
    if video.record_vote(request.ip, params[:vote])
      flash[:notice] = 'Your vote was successful. :)'
    else
      flash[:notice] = 'Your vote was invalid. :('
    end
    redirect back
  end

  # Redirects the user to a Facebook Login.
  get '/facebook_login' do
    redirect GraphAPI.auth_url
  end

  # Creates or Finds a user by their facebook_id and logs them in.
  get '/facebook_callback' do
    facebook_user = GraphAPI.new(false, params[:code])
    @current_user = User.fetch_user(facebook_user)
    session[:user_id] = current_user.id
    flash[:notice] = 'You are now signed in! :)'
    redirect to('/')
  end

  # Signs the user out of this site and out of Facebook as per their TOS.
  get '/logout' do
    target_url = if current_user.access_token.empty?
      to('/')
    else
      current_user.logout_url
    end
    session.clear
    redirect target_url
  end
end
