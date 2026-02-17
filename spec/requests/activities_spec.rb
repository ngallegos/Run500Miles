require 'spec_helper'

describe "Activities", type: :request do

  before(:each) do
    @user = create(:user)
    post '/sessions', params: { session: { email: @user.email, password: @user.password } }
  end

  describe "creation" do

    describe "failure" do
      it "should not make a new activity" do
        expect {
          post '/activities', params: { activity: { activity_date: nil, distance: nil,
                                                    hours: nil, minutes: nil } }
        }.not_to change(Activity, :count)
      end
    end

    describe "success" do
      it "should make a new activity" do
        expect {
          post '/activities', params: { activity: { activity_date: Date.today, distance: 2.0,
                                                    hours: 0, minutes: 25, activity_type: 1 } }
        }.to change(Activity, :count).by(1)
      end
    end
  end
end
