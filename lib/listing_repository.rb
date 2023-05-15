require_relative './listing'
require_relative './database_connection'

class ListingRepository
  def create(listing)
    fail "Listing already exists" if all.map { |current_listings| 
    current_listings.listing_name }.include?(listing.listing_name)

    fail "Missing input" if listing.user_id == nil || listing.user_id == ""

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
    sql = 'SELECT * FROM listings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    listings = []
    result_set.each do |record|
      listings << record_to_listing(record)
    end
    return listings
  end

  def find_host_name(listing)
    sql = 'SELECT users.name,
                users.id,
                listings.user_id
          FROM users
          JOIN listings
          ON users.id = listings.user_id
          WHERE users.id = $1;'
    params = [listing.user_id]

    result_set = DatabaseConnection.exec_params(sql, params)

    host_name = result_set.first['name']
    return host_name
  end

  private

  def record_to_listing(record)
    listing = Listing.new
    listing.id = record['id'].to_i
    listing.listing_name = record['listing_name']
    listing.listing_description = record['listing_description']
    listing.price = record['price'].to_i
    listing.user_id = record['user_id'].to_i
    return listing
  end
end