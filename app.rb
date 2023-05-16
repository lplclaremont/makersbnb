# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

require_relative 'lib/database_connection'
require_relative 'lib/user_repo'
require_relative 'lib/listing_repository'

DatabaseConnection.connect('makersbnb')

class Application < Sinatra::Base
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    go_to_homepage
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

    return erb(:signup) if !repo.create(new_user)
    
    user = repo.find_by_email(new_user.email)
    session[:user_id] = user.id

    go_to_homepage
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    session[:user_id] = UserRepo.new.log_in(params[:email], params[:password])

    @session_id = session[:user_id]
    return erb(:login) if @session_id.nil?
    go_to_homepage
  end

  get '/logout' do
    session[:user_id] = nil
    go_to_homepage
  end

  get '/listing/new' do
    return erb(:new_listing)
  end

  post '/listing/new' do
    if invalid_listing_params
      status 400
      return "We didn't like that... go back to try again!"
    end
    
    begin
      post_listing
    rescue RuntimeError => e
      status 400
      if e.message == 'Missing user id'
        return 'Sorry, try <a href="/login">logging in</a> to add a listing!'
      else
        return 'This listing already exists, try again!'
      end
    end
  end

  get '/listing/:id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:id])

    return erb(:listing_details)
  end

  private

  def go_to_homepage
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    @session_id = session[:user_id]
    return erb(:index)
  end

  def invalid_listing_params
    if params['listing_name'] == nil ||
      params['listing_description'] == nil ||
      params['price'] == nil
      return true
    end
    if params['listing_name'] == '' ||
      params['listing_description'] == '' ||
      params['price'] == ''
      return true
    end
    return false
  end

  def post_listing
    repo = ListingRepository.new
    listing = Listing.new
    listing.listing_name = params['listing_name']
    listing.listing_description = params['listing_description']
    listing.price = params['price'].to_i
    listing.user_id = session[:user_id]
    repo.create(listing)

    return erb(:listing_created)
  end
end
