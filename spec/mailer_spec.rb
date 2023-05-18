require 'mailer'

RSpec.describe Mailer do
  context 'send' do
    it 'sends an email' do
      mailer = Mailer.new
      expect(mailer.send).to eq 'Email sent'
    end
  end
end
