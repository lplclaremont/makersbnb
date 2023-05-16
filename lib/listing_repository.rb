require_relative './listing'
require_relative './database_connection'
require 'date'

class ListingRepository
  def create(listing)
    fail "Listing already exists" if all.map { |current_listings| 
    current_listings.listing_name }.include?(listing.listing_name)

    fail "Missing user id" if listing.user_id == nil || listing.user_id == ""

    sql = 'INSERT INTO listings 
    (listing_name, listing_description, price, user_id)
    VALUES ($1, $2, $3, $4)'
    params = [
      listing.listing_name,
      listing.listing_description,
      listing.price,
      listing.user_id
    ]

    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def all
    sql = 'SELECT listings.id, listings.listing_name, listings.listing_description,
          listings.price, listings.user_id, users.name
          FROM listings JOIN users
          ON users.id = listings.user_id;'
    result_set = DatabaseConnection.exec_params(sql, [])

    listings = []
    result_set.each do |record|
      listings << record_to_listing(record)
    end
    return listings
  end

  def add_dates(id, start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    date_repo = DateRepository.new
    (start_date).upto(end_date).each do |day|
      date = DateModel.new
      date.date = day.to_s 
      date.listing_id = id
      date_repo.create(date)
    end
  end

  private

  def record_to_listing(record)
    listing = Listing.new
    listing.id = record['id'].to_i
    listing.listing_name = record['listing_name']
    listing.listing_description = record['listing_description']
    listing.price = record['price'].to_i
    listing.user_id = record['user_id'].to_i
    listing.host_name = record['name']
    return listing
  end
end
