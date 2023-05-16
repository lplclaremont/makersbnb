require "date_repository"

RSpec.describe DateRepository do
  before(:each) do
    reset_tables
  end

  context "#creates new date" do
    it "adds new date to a listing" do
      repo = DateRepository.new
      date = DateModel.new
      date.date = "2023-10-10"
      date.listing_id = 1

      repo.create(date)
      new_date = repo.all.last

      expect(new_date.date).to eq "2023-10-10"
      expect(new_date.listing_id).to eq 1
    end

    it "adds 2 new dates to listing" do
      repo = DateRepository.new
      date1 = DateModel.new
      date2 = DateModel.new
      date1.date = "2023-10-10"
      date1.listing_id = 1
      date2.date = "2023-10-12"
      date2.listing_id = 1
      repo.create(date1)
      repo.create(date2)

      expect(repo.all[-2].date).to eq "2023-10-10"
      expect(repo.all[-2].listing_id).to eq 1
      expect(repo.all[-1].date).to eq "2023-10-12"
      expect(repo.all[-1].listing_id).to eq 1
    end

    it "throws error when date already exists" do
      repo = DateRepository.new
      date = DateModel.new
      date.date = "2023-05-12"
      date.listing_id = 1

      expect { repo.create(date) }.to raise_error "Date already exists for this listing"
    end
  end
end
