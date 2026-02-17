require 'spec_helper'

describe Activity do
  before(:each) do
    @user = create(:user)
    @attr = { activity_date: Date.today, distance: 2.0, hours: 0, minutes: 25, activity_type: 1 }
  end

  it "should create a new instance given valid attributes" do
    @user.activities.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @activity = @user.activities.create(@attr)
    end

    it "should have a user attribute" do
      @activity.should respond_to(:user)
    end

    it "should have the right associated user" do
      @activity.user_id.should == @user.id
      @activity.user.should == @user
    end
  end

  describe "validations" do
    it "should require a user id" do
      Activity.new(@attr).should_not be_valid
    end

    it "should require an activity date" do
      @user.activities.build(activity_date: nil).should_not be_valid
    end

    it "should reject an activity date in the future" do
      @user.activities.build(activity_date: Date.tomorrow).should_not be_valid
    end

    it "should require a distance" do
      @user.activities.build(distance: nil).should_not be_valid
    end

    it "should reject 0 distances" do
      @user.activities.build(distance: 0.0).should_not be_valid
    end

    it "should require hours" do
      @user.activities.build(hours: nil).should_not be_valid
    end

    it "should require minutes" do
      @user.activities.build(minutes: nil).should_not be_valid
    end

    it "should reject 0 hours and 0 minutes" do
      @user.activities.build(hours: 0, minutes: 0).should_not be_valid
    end
  end
end
