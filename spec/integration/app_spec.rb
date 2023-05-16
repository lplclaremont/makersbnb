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

    it "shows all listings" do
      response = get("/")

      expect(response.body).to include("Property name: Swamp")
      expect(response.body).to include("Price per night: £69")
      expect(response.body).to include("Hosted by: Shrek")
      expect(response.body).to include('<a href="/listing/1">')
      
      expect(response.body).to include("Property name: Far Far Away Castle")
      expect(response.body).to include("Price per night: £420")
      expect(response.body).to include("Hosted by: Fiona")
      expect(response.body).to include('<a href="/listing/2">')
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
    
    it 'should return to sign up form if email already taken' do
      response = post(
        '/signup',
        name: 'Dragon',
        email: 'donkey@donkey.com',
        password: 'lust_for_donkey'
        )
  
      expect(response.status).to eq 200
      expect(response.body).to include '<form'
      expect(response.body).to include '<input type="text" placeholder="Name" required="required" name="name">'
      expect(response.body).to include '<input type="text" placeholder="Email" required="required" name="email">'
      expect(response.body).to include '<input type="password" placeholder="Password" required="required" name="password">'
    end
  end

  context 'GET /login' do
    it 'should show the login form' do
      response = get('/login')

      expect(response.status).to eq 200
      expect(response.body).to include '<input type="text" placeholder="Email" required="required" name="email">'
      expect(response.body).to include '<input type="password" placeholder="Password" required="required" name="password">'
    end
  end
  
  context 'POST /login' do
    it 'should log in' do
      response = post(
        '/login',
        email: 'shrek@swamp.com',
        password: 'fiona_lover420'
        )
        
      expect(response.status).to eq 200
      expect(response.body).not_to include '<a href="/signup">Sign up</a>'
      expect(response.body).not_to include '<a href="/login">Log in</a>'
      expect(response.body).to include '<a href="/account">Account page</a>'
      expect(response.body).to include '<a href="/logout">Log out</a>'
    end
    
    it 'should fail to log in if password is wrong' do
      response = post(
        '/login',
        email: 'shrek@swamp.com',
        password: 'fiona_lover42'
        )
        
      expect(response.status).to eq 200
      expect(response.body).to include '<input type="text" placeholder="Email" required="required" name="email">'
      expect(response.body).to include '<input type="password" placeholder="Password" required="required" name="password">'
    end
  end
    
  context 'GET /logout' do
    it 'logs out' do
      response = get('/logout')
        
      expect(response.status).to eq 200
        
      expect(response.body).to include '<a href="/signup">Sign up</a>'
      expect(response.body).to include '<a href="/login">Log in</a>'
      expect(response.body).not_to include '<a href="/logout">Log out</a>'
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
    it "adds a new listing when user logged in" do
      session = { user_id: 1 }
      params = {
        listing_name: "New Listing",
        listing_description: "Description",
        price: 0
      }

      response = post("/listing/new", params, 'rack.session' => session)

      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Makersbnb</h1>")
      expect(response.body).to include('<p>Your new listing has been added!</p>')
    end

    it "runs error if no user logged in" do
      session = { user_id: nil }
      params = {
        listing_name: "New Listing",
        listing_description: "Description",
        price: 0
      }

      response = post("/listing/new", params, 'rack.session' => session)

      expect(response.status).to eq 400
      expect(response.body).to include('Sorry, try <a href="/login">logging in</a> to add a listing!')
    end

    it "runs error if parameters not valid" do
      session = { user_id: 1 }
      params = {
        listing_name: "",
        listing_description: "",
        price: "hello?"
      }
      response = post("/listing/new", params, 'rack.session' => session)
      
      expect(response.status).to eq 400
      expect(response.body).to eq("We didn't like that... go back to try again!")
    end
  end

  context 'GET /account' do
    xit 'returns the account page for the logged in user' do
      session = { user_id: 1 }
      response = get('/account', 'rack.session' => session)

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Welcome Shrek</h1>'
      expect(response.body).to include 'Listings: 1'
      expect(response.body).to include 'Property name: Swamp'
      expect(response.body).to include 'Price per night: £69'
      expect(response.body).to include 'Hosted by: Shrek'
    end
  end
end
