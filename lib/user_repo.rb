require_relative 'database_connection'
require_relative 'user'

class UserRepo
  def all
    users = []
    sql = 'SELECT * FROM users;'
    results = DatabaseConnection.exec_params(sql, [])

    results.each do |record|
      user = User.new
      user.id = record['id']
      user.name = record['name']
      user.email = record['email']
      user.password = record['password']

      users << user
    end

    return users
  end
end
