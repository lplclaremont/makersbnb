require 'user_repo'

RSpec.describe UserRepo do
  before(:each) do
    reset_tables
  end

  context "find" do
    it "returns all users" do
      repo = UserRepo.new

      users = repo.all
      expect(users.length).to eq 3
      expect(users.name.first).to eq 'Shrek'
      expect(users.name.last).to eq 'Donkey'
    end
  end
end
