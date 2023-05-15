# frozen_string_literal: true

require "spec_helper"
require "rack/test"
require_relative "../../app"
require "json"

describe Application do
  before(:each) do
    reset_tables
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  context "GET /" do
    it "should get the homepage" do
      response = get("/")

      expect(response.status).to eq(200)
    end
  end

  context 'GET /signup' do
    it 'should get the signup page' do
      response = get('/signup')

      expect(response.status).to eq 200
      expect(response.body).to include '<form'
      expect(response.body).to include '<input type="text" placeholder="Name" required="required" name="name">'
      expect(response.body).to include '<input type="text" placeholder="Email" required="required" name="email">'
      expect(response.body).to include '<input type="password" placeholder="Password" required="required" name="password">'
    end
  end

  context 'POST /signup' do
    it 'should create and log in to a new user account' do
      response = post(
        '/signup',
        name: 'Dragon',
        email: 'elizabeth@dragonskeep.com',
        password: 'lust_for_donkey'
        )

      expect(response.status).to eq 200
      expect(response.body).not_to include '<a href="/signup">Sign up</a>'
      expect(response.body).not_to include '<a href="/login">Log in</a>'
      expect(response.body).to include '<a href="/logout">Log out</a>'
    end
  end

  context 'GET /login' do
    it 'should show the login form' do
      response = get('/login')

      expect(response.status).to eq 200
      expect(response.body).to include '<input type="text" placeholder="Name" required="required" name="name">'
      expect(response.body).to include '<input type="text" placeholder="Email" required="required" name="email">'
      expect(response.body).to include '<input type="password" placeholder="Password" required="required" name="password">'
    end
  end
  
  context "GET /listing/new" do
    it "contains a form for a new listing" do
      response = get "/listing/new"

      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Makersbnb</h1>")
      expect(response.body).to include('<form action="/listing/new" method="POST">')
      expect(response.body).to include('<input type="text" name="listing_name">')
    end
  end

  context "POST /listing/new" do
    it "adds a new listing" do
      response = post("/listing/new", listing_name: "New Listing", listing_description: "Description", price: 0, user_id: 1)

      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Makersbnb</h1>")
      expect(response.body).to include('<p>Your new listing has been added!</p>')
    end
  end
end
