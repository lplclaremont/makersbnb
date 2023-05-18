require 'mail'

class Mailer
  def initialize
    options = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'gmail.com',
      user_name: 'shrekfrommakersbnb@gmail.com',
      password: 'oxjwquviyyhjckqr',
      authentication: 'plain'
    }

    Mail.defaults do
      delivery_method :smtp, options
    end
  end

  def send(email_type, email_address)
    subject = generate_subject(email_type)
    body = generate_body(email_type)

    return 'Email failed to send.' unless subject || body
    
    Mail.deliver do
      to email_address
      from 'Shrek @ MakersBnB'
      subject subject
      body body
    end

    return "#{email_type} email sent"
  end

  def generate_subject(email_type)
    case email_type
    when 'signup'
      return 'Welcome to MakersBnB!'
    when 'createlisting'
      return 'You created a new listing!'
    when 'updatelisting'
      return 'You updated your listing!'
    when 'bookingrequested'
      return 'New booking request received!'
    when 'confirmrequest'
      return 'You approved a booking!'
    when 'requestbooking'
      return 'You requested a new booking!'
    when 'requestconfirmed'
      return 'Your booking request has been confirmed!'
    when 'requestdenied'
      return 'Your booking request has been denied.'
    else
      return false
    end
  end

  def generate_body(email_type)
    case email_type
    when 'signup'
      return 'Welcome to MakersBnB!'
    else
      return false
    end
  end
end
