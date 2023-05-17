require 'date_repository'

RSpec.describe DateRepository do

  def reset_dates_table #reads a file uses a PG gems to contect to the database

    seed_sql = File.read('spec/seeds/test_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_dates_table
  end

  context '#find_by_listing' do
    it 'returns the dates' do
      repo = DateRepository.new

      response = repo.find_by_listing(1)
      
      puts response
      expect(response).to eq ""

    end
  end
end