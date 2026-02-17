require 'spec_helper'

describe "FriendlyForwardings", type: :request do
  it "should forward to the requested page after signin" do
    user = create(:user)
    # Attempt to visit a protected page
    get edit_user_path(user)
    expect(response).to redirect_to(signin_path)

    # Sign in
    post '/sessions', params: { session: { email: user.email, password: user.password } }

    # Should redirect to the originally requested edit page
    expect(response).to redirect_to(edit_user_path(user))
  end
end
