require_relative "booking"

class BookingRepo
  def all
    sql = "SELECT users.id AS booking_user_id, 
	        users.name AS booking_user_name,
	        listings.id AS listing_id,
	        dates.id AS date_id,
	        dates.date
    	    FROM users 
    		JOIN dates_users_join ON dates_users_join.user_id = users.id
    		JOIN dates ON dates_users_join.dates_id = dates.id
    		JOIN listings ON dates.listing_id = listings.id;"
    result_set = DatabaseConnection.exec_params(sql, [])

    bookings = []
    result_set.each do |record|
      
      bookings << record_to_booking(record)
    end
    return bookings
  end

  def create(booking)
    fail "Booking already exists, try again." if booking_exists?(booking)

    sql = "INSERT INTO dates_users_join (user_id, dates_id)
          VALUES ($1, $2);"
    params = [booking.booking_user_id, booking.date_id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  private

  def booking_exists?(booking)
    all.any? { |existing_booking|
      existing_booking.booking_user_id == booking.booking_user_id &&
      existing_booking.date_id == booking.date_id
    }
  end

  def record_to_booking(record)
    booking = Booking.new
    booking.booking_user_id = record["booking_user_id"].to_i
    booking.date_id = record["date_id"].to_i
    booking.listing_id = record["listing_id"].to_i
    booking.booking_user_name = record["booking_user_name"]
    booking.date = record["date"]

    return booking
  end
end
