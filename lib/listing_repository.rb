require_relative './listing'
require_relative './database_connection'

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

  def all_by_id(user_id)
    sql = 'SELECT listings.*, users.name
      FROM listings JOIN users
      ON users.id = listings.user_id
      WHERE users.id=$1;'

    results = DatabaseConnection.exec_params(sql, [user_id])
    listings = []
    results.each do |record|
      listings << record_to_listing(record)
    end
    return listings

  def find(id) 
    sql = 'SELECT listings.id, listings.listing_name, listings.listing_description,
          listings.price, listings.user_id, users.name
          FROM listings JOIN users
          ON users.id = listings.user_id
          WHERE listings.id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    
    return record_to_listing(result_set[0])
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
