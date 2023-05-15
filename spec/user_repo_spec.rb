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

    it 'returns a single user from email' do
      repo = UserRepo.new
      user = repo.find_by_email('shrek@swamp.com')
      expect(user.name).to eq 'Shrek'
    end

    it 'returns nil if email doesnt exist' do
      repo = UserRepo.new
      user = repo.find_by_email('shreky@swamp.com')
      expect(user).to eq false
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

    it 'doesnt make user if email is taken' do
      repo = UserRepo.new

      new_user = User.new
      new_user.name = 'Muffin Man'
      new_user.email = 'shrek@swamp.com'
      new_user.password = 'do_you_know_the_muffin_man'

      repo.create(new_user)
      expect(repo.all.length).to eq 3
    end
  end
end
