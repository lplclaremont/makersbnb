# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'

DatabaseConnection.connect('makersbnb')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/listing/new' do
    return erb(:new_listing)
  end

  post '/listing/new' do 
    #post("/listing/new", listing_name: "New Listing", listing_description: "Description", price: 0, user_id: 1)
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
