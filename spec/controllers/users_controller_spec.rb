require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.fname)
    end
    
    it "should include the users's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.fname)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "GET 'signup'" do
    it "should be successful" do
      get 'signup'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'signup'
      response.should have_selector("title", :content=> "Sign Up")
    end
  end

end
