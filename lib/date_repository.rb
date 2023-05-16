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

  private

  def date_exists?(date)
    all.any?{ |existing_date|
          existing_date.date == date.date &&
          existing_date.listing_id == date.listing_id
        }
  end

  def record_to_date(record)
    date = DateModel.new
    date.id = record['id'].to_i
    date.date = record['date']
    date.listing_id = record['listing_id'].to_i
    return date
  end
end
