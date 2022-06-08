require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  # Initialize test data
  let!(:categories) { create_list(:category, 5) }
  let!(:category_id) { categories.first.id }
  let(:end_point) { '/api/v1/categories' }

  # Test suite for GET /categories
  describe 'GET /categories' do
    # make HTTP get requests before each example
    before { get end_point }

    it 'returns categories' do
      expect(json).not_to be_empty
      expect(json.length).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /categories/:id
  describe 'GET /categories/:id' do
    context 'when the category is found' do
      before { get end_point.concat("/#{category_id}") }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the right category' do
        expect(json['id']).to eq(category_id)
      end
    end

    context 'when the category is not found' do
      before { get end_point.concat("/WRONG_ID") }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for POST /categories
  describe 'POST /categories' do
    context 'when the request is valid' do
      let(:valid_name) { { name: 'Horror' } }
      before { post end_point, params: valid_name }
      it 'creates a category' do
        expect(json['name']).to eq('Horror')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post end_point, params: { name: '' } }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to include('is too short')
      end
    end
  end

  # Test suite for PUT /categories

  # Test suite for DELETE /categories/:id
  describe 'DELETE /categories/:id' do
    context 'when the category is found' do
      before { delete end_point.concat("/#{category_id}") }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the category is not found' do
      before { delete end_point.concat("/WRONG_ID") }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
