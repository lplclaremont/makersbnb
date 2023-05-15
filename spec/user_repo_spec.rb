require 'user_repo'

RSpec.describe UserRepo do
  before(:each) do
    reset_tables
  end

  context 'find' do
    it 'returns all users' do
      repo = UserRepo.new

      users = repo.all
      expect(users.length).to eq 3
      expect(users.first.name).to eq 'Shrek'
      expect(users.last.name).to eq 'Donkey'
    end
  end
end
