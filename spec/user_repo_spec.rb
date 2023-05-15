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

  context 'create' do
    it 'creates a new user' do
      repo = UserRepo.new

      new_user = User.new
      new_user.name = 'Muffin Man'
      new_user.email = 'muffinman@drury.lane'
      new_user.password = 'do_you_know_the_muffin_man'
      
      repo.create(new_user)
      expect(repo.all.length).to eq 4
      expect(repo.all.last.name).to eq 'Muffin Man'
    end
  end
end
