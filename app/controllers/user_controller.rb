class UsersController < ApplicationController
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/signup' do
    if !logged_in?
      erb :'users/create_user', locals: {message: "Please sign up before you sign in"}
    else
      redirect to '/tweets'
    end
  end



  post '/signup' do
    # raise params.inspect
    # params = {"username"=>"Nancy", "email"=>"nancy@yahoo.com", "password"=>"asdf"}
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      "Sorry, can you go back and fill out all three fields: Name, email, and password?"
      # redirect to '/signup'
    elsif logged_in?
      redirect to '/tweets'
    elsif
      user = User.find_by(:username => params[:username])
      if
        user.username == params[:username] && user.email == params[:email]
        "Oops, sorry but that name and password are already taken!"
      end

    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    end
  end


  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      erb :'users/login_error'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end
end
