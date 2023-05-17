require 'booking_repo'

RSpec.describe BookingRepo do
  before(:each) do
    reset_tables
  end

  context '#all method' do
    it 'returns all current booking requests' do 
      repo = BookingRepo.new
      bookings = repo.all
      expect(bookings.length).to eq 3

      expect(bookings.first.booking_user_id).to eq(3)
      expect(bookings.first.date_id).to eq(1)
      expect(bookings.first.listing_id).to eq(1)
      expect(bookings.first.booking_user_name).to eq("Donkey")
      expect(bookings.first.date).to eq("2023-05-12")
      expect(bookings.last.booking_user_id).to eq(3)
      expect(bookings.last.date_id).to eq(2)
      expect(bookings.last.listing_id).to eq(1)
      expect(bookings.last.booking_user_name).to eq("Donkey")
      expect(bookings.last.date).to eq("2023-05-13")
    end
  end

  context '#create method' do
    it 'creates new booking request' do
      repo = BookingRepo.new
      booking = Booking.new
      booking.booking_user_id = 1
      booking.date_id = 1
      repo.create(booking)
      new_booking = repo.all.last

      expect(new_booking.booking_user_id).to eq 1
      expect(new_booking.date_id).to eq 1
    end

    it 'throws an error when booking request already exists' do
      repo = BookingRepo.new
      booking = Booking.new
      booking.booking_user_id = 3
      booking.date_id = 1
      expect{ repo.create(booking) }.to raise_error "Booking already exists, try again."
    end
  end
end
