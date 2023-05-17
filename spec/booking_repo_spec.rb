require 'booking_repo'

RSpec.describe BookingRepo do
  before(:each) do
    reset_tables
  end

  context 'using the listing id' do
    it 'finds multiple requests' do
      repo = BookingRepo.new
      results = repo.find_requests_by_listing_id(1)
      expect(results.length).to eq 3
      expect(results.first.booking_user_name).to eq 'Donkey'
      expect(results.first.date).to eq '2023-05-12'
      expect(results[1].booking_user_name).to eq 'Fiona'
      expect(results[1].date).to eq '2023-05-12'
      expect(results.last.booking_user_name).to eq 'Donkey'
      expect(results.last.date).to eq '2023-05-13'
    end

    it 'finds no requests when listing doesnt have any' do
      repo = BookingRepo.new
      expect(repo.find_requests_by_listing_id(2)).to eq false
    end

    it 'it fails when the listing doesnt exist' do
      repo = BookingRepo.new
      expect(repo.find_requests_by_listing_id(3)).to eq false
    end
  end
end
