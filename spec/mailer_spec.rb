require 'mailer'

RSpec.describe Mailer do
  context 'send' do
    it 'sends an email' do
      mailer = Mailer.new
      expect(mailer.send('signup', 'email@email.com')).to eq 'Email sent'
    end
  end

  context 'generate_subject method' do
    it 'generates the sign up subject line' do
      mailer = Mailer.new
      subject = mailer.generate_subject('signup')
      expect(subject).to eq 'Welcome to MakersBnB!'
    end
    
    it 'returns false if email_type does not exist' do
      mailer = Mailer.new
      expect(mailer.generate_subject('subject not present')).to eq false
    end
  end
  
  context 'generate_body method' do
    it 'generates the body of the email for sign up' do
      mailer = Mailer.new
      body = mailer.generate_body('signup')
      expect(body).to eq 'Welcome to MakersBnB!'
    end

    it 'returns false if the email_type does not exist' do
      mailer = Mailer.new
      expect(mailer.generate_body('subject not present')).to eq false
    end
  end
end
