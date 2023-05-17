# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

require_relative 'lib/database_connection'
require_relative 'lib/user_repo'
require_relative 'lib/listing_repository'
require_relative 'lib/date_repository'

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

  get '/account' do
    return erb(:login) if session[:user_id].nil?
    repo = UserRepo.new
    listing_repo = ListingRepository.new
    @user = repo.find_by_id(session[:user_id])
    @listings = listing_repo.all_by_id(session[:user_id])
    return erb(:account_page)
  end

  get '/account-settings' do
    account_settings_access
  end

  post '/account-settings' do
    password = params[:password]
    @can_update = UserRepo.new.check_password(session[:user_id], password)
    @user = UserRepo.new.find_by_id(session[:user_id])
    return erb(:account_settings)
  end

  get '/update-username-email' do
    account_settings_access
  end

  post '/update-username-email' do
    @can_update = true
    repo = UserRepo.new
    params[:name] == "" ? name = nil : name = params[:name]
    params[:email] == "" ? email = nil : email = params[:email]

    repo.update(session[:user_id], email, name)
    @user = repo.find_by_id(session[:user_id])
    return erb(:account_settings)
  end

  get '/update-password' do
    account_settings_access
  end

  post '/update-password' do
    @can_update = true
    repo = UserRepo.new
    id = session[:user_id]
    old_password = params[:old_password]
    new_password = params[:new_password]
    confirm_password = params[:confirm_password]
    repo.update_password(id, old_password, new_password, confirm_password)
    @user = repo.find_by_id(id)
    return erb(:account_settings)
  end

  get '/listing/:id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:id])

    return erb(:listing_details)
  end

  get '/available_dates/:id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:id])

    return erb(:add_dates)
  end

  post '/available_dates/:id' do
    if invalid_date_params
      status 400
      return "We didn't like that... go back to try again!"
    end

    repo = ListingRepository.new
    listing = repo.find(params[:id])
    redirect '/login' if session[:user_id] != listing.user_id
    begin
      add_dates_to_listing
    rescue RuntimeError => e
      status 400
      return e.message
    end
  end

  post '/book/:id' do 
    redirect '/login' if session[:user_id] == nil
    begin 
      user_id = session[:user_id]
      date_id = params[:id].to_i
      booking = Booking.new
      booking.booking_user_id = user_id
      booking.date_id = date_id
      repo = BookingRepo.new
      repo.create(booking)

      return "Booking request successfully added!"
    rescue RuntimeError 
      status 400
      return "Booking already exists, try again."
    end
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

  def invalid_date_params
    if params['start_date'] == nil ||
      params['end_date'] == nil
      return true
    end
    if params['start_date'] == '' ||
      params['end_date'] == ''
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

  def add_dates_to_listing
    repo = DateRepository.new
    id = params[:id].to_i
    start_date = params[:start_date]
    end_date = params[:end_date]
    repo.add_dates(id, start_date, end_date)
    return erb(:dates_added)
  end

  def account_settings_access
    return erb(:login) if session[:user_id].nil?
    return erb(:account_settings)
  end
end