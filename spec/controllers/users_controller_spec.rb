require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user  = test_sign_in(create(:user))
        second = create(:user, fname: "Bob", email: "another@example.com")
        third  = create(:user, fname: "Ben", email: "another@example.net")

        @users = [@user, second, third]
        30.times do
          @users << create(:user, fname: generate(:fname),
                                  lname: generate(:lname),
                                  email: generate(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_successful
      end

      it "should have the right title" do
        get :index
        expect(response.body).to include("All Users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          expect(response.body).to include(user.fname)
        end
      end

      it "should paginate users" do
        get :index
        expect(response.body).to include('class="pagination"')
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :show, params: { id: @user }
      response.should be_successful
    end

    it "should find the right user" do
      get :show, params: { id: @user }
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, params: { id: @user }
      expect(response.body).to include(@user.fname)
    end
  end

  describe "GET 'signup'" do
    it "should be successful" do
      get 'signup'
      response.should be_successful
    end

    it "should have the right title" do
      get 'signup'
      expect(response.body).to include("Sign Up")
    end

    it "should have a first name field" do
      get :signup
      expect(response.body).to include('name="user[fname]"')
    end

    it "should have a last name field" do
      get :signup
      expect(response.body).to include('name="user[lname]"')
    end

    it "should have an email field" do
      get :signup
      expect(response.body).to include('name="user[email]"')
    end

    it "should have a password field" do
      get :signup
      expect(response.body).to include('name="user[password]"')
    end

    it "should have a password confirmation field" do
      get :signup
      expect(response.body).to include('name="user[password_confirmation]"')
    end

    it "should have a secret word field" do
      get :signup
      expect(response.body).to include('name="user[secret_word]"')
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { fname: "", lname: "", password: "",
                  password_confirmation: "", secret_word: "" }
      end

      it "should not create a user" do
        expect {
          post :create, params: { user: @attr }
        }.not_to change(User, :count)
      end

      it "should have the right title" do
        post :create, params: { user: @attr }
        expect(response.body).to include("Sign Up")
      end

      it "should render the 'signup' page" do
        post :create, params: { user: @attr }
        response.should render_template('signup')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { fname: "New", lname: "User",
                  email: "user@example.com",
                  password: "foobar", password_confirmation: "foobar",
                  secret_word: "angusbeef" }
      end

      it "should create a user" do
        expect {
          post :create, params: { user: @attr }
        }.to change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, params: { user: @attr }
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, params: { user: @attr }
        flash[:success].should =~ /welcome/i
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, params: { id: @user }
      response.should be_successful
    end

    it "should have the right title" do
      get :edit, params: { id: @user }
      expect(response.body).to include("Edit User")
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { email: "", fname: "", lname: "",
                  password: "", password_confirmation: "" }
      end

      it "should render the 'edit' page" do
        put :update, params: { id: @user, user: @attr }
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, params: { id: @user, user: @attr }
        expect(response.body).to include("Edit User")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { fname: "New", lname: "Name", email: "user@example.org",
                  password: "barbaz", password_confirmation: "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, params: { id: @user, user: @attr }
        @user.reload
        @user.fname.should == @attr[:fname]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, params: { id: @user, user: @attr }
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, params: { id: @user, user: @attr }
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do
    before(:each) do
      @user = create(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, params: { id: @user }
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, params: { id: @user, user: {} }
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = create(:user, email: "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, params: { id: @user }
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, params: { id: @user, user: {} }
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = create(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, params: { id: @user }
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, params: { id: @user }
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = create(:user, email: "admin@example.com", admin: true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        expect {
          delete :destroy, params: { id: @user }
        }.to change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, params: { id: @user }
        response.should redirect_to(users_path)
      end
    end
  end
end
