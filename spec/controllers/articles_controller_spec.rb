require 'rails_helper'
require 'support/macros'

RSpec.describe ArticlesController, type: :controller do

  describe "GET #edit" do
    before do
      @john = User.create(email: "john@example.com", password: "password")
    end

    context "owner is allowed to edit his article" do
      it"renders the edit template" do
        login_user @john
        article = Article.create(title: "first article", body: "body", user: @john)

        get :edit, id: article
        expect(response).to render_template :edit
      end
    end

    context "non-owner is not allowed to edit his article" do
      it "redirects to the root paht" do
        fred = User.create(email: "fred@example.com", password: "password")
        login_user fred
        article = Article.create(title: "first article", body: "body", user: @john)

        get :edit, id: article
        expect(response).to redirect_to(root_path)
        message = "You can only edit your own article."
        expect(flash[:danger]).to eq message

      end
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
