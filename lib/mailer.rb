require 'mail'

# Gmail account info
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

Mail.deliver do
  to 'cshjparker@gmx.co.uk'
  from 'shrekfrommakersbnb@gmail.com'
  subject 'Sending email using Ruby'
  body 'Easy peasy lemon squeezy'
end

puts 'Email sent'
