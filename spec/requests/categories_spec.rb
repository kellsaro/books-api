require "rails_helper"

RSpec.describe "Categories", type: :request do
  # Initialize test data
  let!(:categories) { create_list(:category, 5) }
  let(:category_id) { categories.first.id }
  let(:end_point) { "/api/v1/categories" }
  let(:end_point_with_valid_id) { end_point.concat("/#{category_id}") }
  let(:end_point_with_invalid_id) { end_point.concat("/invalid_category_id") }

  # Test suite for GET /categories
  describe "GET /categories" do
    # make HTTP get requests before each example
    before { get end_point }

    it "returns categories" do
      expect(json).not_to be_empty
      expect(json.length).to eq(5)
    end

    it "returns status code 200(:ok)" do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /categories/:id
  describe "GET /categories/:id" do
    context "when the category is found" do
      before { get end_point_with_valid_id }
      it "returns status code 200(:ok)" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the right category" do
        expect(json["id"]).to eq(category_id)
      end
    end

    context "when the category is not found" do
      before { get end_point_with_invalid_id }
      it "returns status code 404(:not_found)" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Test suite for POST /categories
  describe "POST /categories" do
    context "when the request is valid" do
      let(:valid_name) { {name: "Horror"} }
      before { post end_point, params: valid_name }
      it "creates a category" do
        expect(json["name"]).to eq("Horror")
      end

      it "returns status code 201(:created)" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when the request is invalid" do
      before { post end_point, params: {name: ""} }
      it "returns status code 422(:unprocessable_entity)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a validation failure message" do
        expect(json["error"]).to include("Validation failed")
        expect(json["error"]).to include("is too short")
      end
    end
  end

  # Test suite for PUT /categories

  # Test suite for DELETE /categories/:id
  describe "DELETE /categories/:id" do
    context "when the category is found" do
      before { delete end_point_with_valid_id }

      it "returns status code 204(:no_content)" do
        expect(response).to have_http_status(:no_content)
      end

      it "deletes the category" do
        expect(Category.where(id: category_id)).to be_empty
      end
    end

    context "when the category is not found" do
      before { delete end_point_with_invalid_id }
      it "returns status code 404(:not_found)" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
