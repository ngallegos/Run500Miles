require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      fname:                 "Nick",
      lname:                 "Gallegos",
      email:                 "nick.gallegost@example.com",
      password:              "foobar",
      password_confirmation: "foobar",
      secret_word:           "angusbeef"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a first name" do
    User.new(@attr.merge(fname: "")).should_not be_valid
  end

  it "should require a last name" do
    User.new(@attr.merge(lname: "")).should_not be_valid
  end

  it "should require an email address" do
    User.new(@attr.merge(email: "")).should_not be_valid
  end

  it "should require a secret word" do
    User.new(@attr.merge(secret_word: "")).should_not be_valid
  end

  it "should accept the secret word" do
    User.new(@attr.merge(secret_word: "angusbeef")).should be_valid
  end

  it "should reject incorrect secret words" do
    %w[testword notangusbeef wrongsw].each do |sw|
      User.new(@attr.merge(secret_word: sw)).should_not be_valid
    end
  end

  it "should reject first names that are too long" do
    User.new(@attr.merge(fname: "a" * 51)).should_not be_valid
  end

  it "should reject last names that are too long" do
    User.new(@attr.merge(lname: "a" * 51)).should_not be_valid
  end

  it "should accept valid email addresses" do
    %w[user123@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |address|
      User.new(@attr.merge(email: address)).should be_valid
    end
  end

  it "should reject invalid email addresses" do
    %w[user@foo,com user_at_foo.org example.user@foo.].each do |address|
      User.new(@attr.merge(email: address)).should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr.merge(email: @attr[:email].upcase))
    User.new(@attr).should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(password: "", password_confirmation: "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(password_confirmation: "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      User.new(@attr.merge(password: short, password_confirmation: short)).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      User.new(@attr.merge(password: long, password_confirmation: long)).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_truthy
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_falsey
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password]).should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "activity associations" do

    before(:each) do
      @user = User.create(@attr)
      @ac1  = create(:activity, user: @user, created_at: 1.day.ago)
      @ac2  = create(:activity, user: @user, created_at: 1.hour.ago)
    end

    it "should have an activities attribute" do
      @user.should respond_to(:activities)
    end

    it "should have the right activities in the right order" do
      @user.activities.should == [@ac2, @ac1]
    end

    it "should destroy associated activities" do
      @user.destroy
      [@ac1, @ac2].each do |activity|
        Activity.find_by(id: activity.id).should be_nil
      end
    end

    it "should have a feed" do
      @user.should respond_to(:feed)
    end

    it "should include the user's activities" do
      @user.feed.include?(@ac1).should be_truthy
      @user.feed.include?(@ac2).should be_truthy
    end

    it "should not include a different user's activities" do
      other = create(:user, email: generate(:email), user_type: nil)
      ac3 = create(:activity, user: other)
      @user.feed.include?(ac3).should be_falsey
    end
  end
end
