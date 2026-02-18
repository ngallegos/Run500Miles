require 'spec_helper'

describe "Users", type: :request do

  describe "signup" do

    describe "failure" do
      it "should not make a new user" do
        expect {
          post '/users', params: { user: { fname: "", lname: "", email: "",
                                           password: "", password_confirmation: "",
                                           secret_word: "" } }
        }.not_to change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        expect {
          post '/users', params: { user: { fname: "Test", lname: "User",
                                           email: "test@example.com",
                                           password: "foobar",
                                           password_confirmation: "foobar",
                                           secret_word: "angusbeef" } }
        }.to change(User, :count).by(1)
        expect(response).to be_redirect
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        post '/sessions', params: { session: { email: "", password: "" } }
        expect(response).to render_template('new')
        expect(flash[:error]).to match(/invalid/i)
      end
    end

    describe "success" do
      it "should sign a user in and redirect" do
        user = create(:user)
        post '/sessions', params: { session: { email: user.email, password: user.password } }
        expect(response).to be_redirect
      end
    end
  end
end
