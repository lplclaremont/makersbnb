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

    return 'Email failed to send' unless subject || body
    
    Mail.deliver do
      to email_address
      from 'Shrek @ MakersBnB'
      subject subject
      body body
    end

    return 'Email sent'
  end

  def generate_subject(email_type)
    case email_type
    when 'signup'
      return 'Welcome to MakersBnB!'
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
