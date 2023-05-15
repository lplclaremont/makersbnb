require 'listing_repository'

RSpec.describe ListingRepository do
  before(:each) do
    reset_tables
  end

  context 'the #add method' do
    it 'adds new listing to database' do
      repo = ListingRepository.new
      listing = Listing.new
      listing.listing_name = 'New listing'
      listing.listing_description = 'New description'
      listing.price = 50
      listing.user_id = 1

      repo.add(listing)
      new_listing = repo.all.last

      expect(new_listing.listing_name).to eq('New listing')
      expect(new_listing.listing_description).to eq('New description')
      expect(new_listing.price).to eq(50)
      expect(new_listing.user_id).to eq(1)
    end
  end
end