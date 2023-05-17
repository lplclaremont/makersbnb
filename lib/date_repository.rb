require_relative './date_model'

class DateRepository
  def create(date)
    fail 'Date already exists for this listing' if date_exists?(date)

    sql = 'INSERT INTO dates (date, listing_id)
          VALUES ($1, $2);'
    params = [date.date, date.listing_id]

    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def all
    sql = 'SELECT * FROM dates;'
    result_set = DatabaseConnection.exec_params(sql, [])

    dates = []
    result_set.each do |record|
      dates << record_to_date(record)
    end

    return dates
  end

  def add_dates(id, start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    check_dates(start_date, end_date)

    (start_date).upto(end_date).each do |day|
      date = DateModel.new
      date.date = day.to_s 
      date.listing_id = id
      create(date)
    end
  end

  def find_by_listing(listing_id)
    
    my = 'SELECT * FROM dates WHERE listing_id = 1 ;'
    
    #params = [listing_id]
    results = DatabaseConnection.exec_params(my, [])
    #result_set gives an array of hashes, so for each record so
    #we want to create a new object in the date model class i.e 
    #INFLATING the object with the values of the hash which is done by the record_to_date method
    dates = []

    results.each do |record|
      dates << record_to_date(record)
    end
  
    return dates
  end

  private

  def date_exists?(date)
    all.any?{ |existing_date|
          existing_date.date == date.date &&
          existing_date.listing_id == date.listing_id
        }
  end

  def check_dates(start_date, end_date)
    fail "End date must be after start date" if start_date > end_date
    fail "Start date must not be in the past" if start_date < Date.today
  end

  def record_to_date(record)
    date = DateModel.new
    date.id = record['id'].to_i
    date.date = record['date']
    date.listing_id = record['listing_id'].to_i
    return date
  end
end
