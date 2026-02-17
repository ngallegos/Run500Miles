require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Run 500 Miles"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_successful
    end

    it "should have the right title" do
      get 'home'
      expect(response.body).to include(@base_title + " | Home")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_successful
    end

    it "should have the right title" do
      get 'contact'
      expect(response.body).to include(@base_title + " | Contact Info")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_successful
    end

    it "should have the right title" do
      get 'about'
      expect(response.body).to include(@base_title + " | About")
    end
  end
end
