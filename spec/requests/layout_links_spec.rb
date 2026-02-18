require 'spec_helper'

describe "LayoutLinks", type: :request do

  it "should have a Home page at '/'" do
    get '/'
    expect(response).to be_successful
    expect(response.body).to include("Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    expect(response).to be_successful
    expect(response.body).to include("Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    expect(response).to be_successful
    expect(response.body).to include("About")
  end

  it "should have a Sign Up page at '/signup'" do
    get '/signup'
    expect(response).to be_successful
    expect(response.body).to include("Sign Up")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    expect(response).to be_successful
    expect(response.body).to include("Help")
  end

  describe "when not signed in" do
    it "should include a signin link" do
      get '/'
      expect(response.body).to include(signin_path)
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = create(:user)
      post '/sessions', params: { session: { email: @user.email, password: @user.password } }
    end

    it "should include a signout link" do
      get '/'
      expect(response.body).to include("Sign Out")
    end

    it "should include a profile link" do
      get '/'
      expect(response.body).to include(user_path(@user))
    end
  end
end
