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
    @listing_repo = ListingRepository.new
    @listings = @listing_repo.all
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    @listings_repo = ListingRepository.new
    repo = UserRepo.new
    new_user = User.new

    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo.create(new_user)

    user = repo.find_by_email(new_user.email)
    session[:user_id] = user.id

    @listings = @listings_repo.all
    @session_id = session[:user_id]
    return erb(:index)
  end

  get '/login' do
    return erb(:login)
  end

  get '/listing/new' do
    return erb(:new_listing)
  end

  post '/listing/new' do
    repo = ListingRepository.new
    listing = Listing.new
    listing.listing_name = params['listing_name']
    listing.listing_description = params['listing_description']
    listing.price = params['price'].to_i
    listing.user_id = params['user_id'].to_i
    repo.create(listing)

    return erb(:listing_created)
  end
end
