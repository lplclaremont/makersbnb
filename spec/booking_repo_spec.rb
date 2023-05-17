require 'booking_repo'

RSpec.describe BookingRepo do
  before(:each) do
    reset_tables
  end

  context 'using the listing id' do
    it 'finds multiple requests' do
      repo = BookingRepo.new
      results = repo.find_requests_by_listing_id(1)
      expect(results.length).to eq 2 
      expect(results.first.booking_user_name).to eq 'Donkey'
      expect(results.first.date).to eq '2023-05-12'
      expect(results.last.booking_user_name).to eq 'Fiona'
      expect(results.last.date).to eq '2023-05-12'
    end

    xit 'finds no requests when listing doesnt have any' do

    end

    xit 'it fails when the listing doesnt exist' do

    end
  end
end
