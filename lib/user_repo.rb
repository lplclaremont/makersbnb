require 'bcrypt'
require_relative 'database_connection'
require_relative 'user'

class UserRepo
  def all
    users = []
    sql = 'SELECT * FROM users;'
    results = DatabaseConnection.exec_params(sql, [])

    results.each do |record|
      users << user(record)
    end

    return users
  end

  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email=$1;'
    result = DatabaseConnection.exec_params(sql, [email]).first
    return false if result.nil?
    return user(result)
  end

  def create(new_user)
    return false if find_by_email(new_user.email)
    encrypted_password = BCrypt::Password.create(new_user.password)

    sql = 'INSERT INTO users (name, email, password) VALUES ($1, $2, $3);'
    params = [new_user.name, new_user.email, encrypted_password]

    DatabaseConnection.exec_params(sql, params)
  end

  def log_in(email, password)
    user = find_by_email(email)
    return nil if !user
    BCrypt::Password.new(user.password) == password ? user.id.to_i : nil
  end

  private

  def user(record)
    user = User.new
    user.id = record['id']
    user.name = record['name']
    user.email = record['email']
    user.password = record['password']
    
    return user
  end
end
