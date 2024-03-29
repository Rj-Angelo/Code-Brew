require 'rails_helper'

RSpec.describe "Puzzles", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/puzzles/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/puzzles/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/puzzles/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/puzzles/create"
      expect(response).to have_http_status(:success)
    end
  end

end
