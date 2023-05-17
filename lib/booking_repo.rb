require_relative 'booking'

class BookingRepo

  def find_requests_by_listing_id(listing_id)
    requests = []
    sql = 'SELECT users.id AS booking_user_id, 
            users.name AS booking_user_name,
            listings.id AS listing_id,
            dates.id AS date_id,
            dates.date
                FROM users 
                  JOIN dates_users_join ON dates_users_join.user_id = users.id
                  JOIN dates ON dates_users_join.dates_id = dates.id
                  JOIN listings ON dates.listing_id = listings.id
                WHERE listing_id=$1;'
    results = DatabaseConnection.exec_params(sql, [listing_id])
    return false if results.first.nil?
    results.each do |result|
      requests << new_booking(result)
    end
    return requests
  end
  
  private

  def new_booking(result)
    request = Booking.new
    request.booking_user_id = result['booking_user_id']
    request.booking_user_name = result['booking_user_name']
    request.listing_id = result['listing_id']
    request.date_id = result['date_id']
    request.date = result['date']
    request
  end
end
