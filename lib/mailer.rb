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

  def send
    Mail.deliver do
      to 'b.wilton1993@gmail.com'
      from 'Shrek @ MakersBnB'
      subject 'Sending email using Ruby'
      body 'Easy peasy lemon squeezy'
    end

    return 'Email sent'
  end
end
