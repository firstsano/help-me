shared_examples "authenticable controller" do
  it "returns unauthorized status when user is not signed in" do
    sign_out user
    controller_request
    if response.request.format.html?
      expect(response).to redirect_to new_user_session_path
    else
      expect(response).to have_http_status :unauthorized
    end
  end
end
