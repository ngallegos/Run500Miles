require 'spec_helper'

describe "Activities" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :activity_comment, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Activity, :count)
      end
    end

    describe "success" do
  
      it "should make a new micropost" do
        comment = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :activity_distance, :with => 1.0
          fill_in :activity_hours, :with => 1
          fill_in :activity_minutes, :with => 1
          fill_in :activity_comment, :with => comment
          click_button
          response.should have_selector("span.content", :content => comment)
        end.should change(Activity, :count).by(1)
      end
    end
  end
end
