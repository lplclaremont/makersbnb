# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/user_repo'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    repo = UserRepo.new
    new_user = User.new

    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo.create(new_user)

    user = repo.find_by_email(new_user.email)
    session[:user_id] = user.id

    @session_id = session[:user_id]
    return erb(:index)
  end

  get '/login' do
    return erb(:login)
  end

  
end
