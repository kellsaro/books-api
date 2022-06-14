require 'rails_helper'
require './spec/support/shared_examples/authentication_error'

RSpec.describe "Books", type: :request do
  # Initialize test data
  let(:user) { FactoryBot.create(:user, username: 'acushla', password: 'password_1234') }
  let(:authorization_header) { { 'Authorization' => 'Bearer '.concat(AuthenticationTokenService.call(user.id)) } }
  let!(:books) { create_list(:book, 5, user: user) }
  let(:book_id) { 1 }
  let(:end_point) { '/api/v1/books' }
  let(:end_point_with_valid_id) { end_point.concat("/1") }
  let(:end_point_with_invalid_id) { end_point.concat("/invalid_book_id") }

  # Test suite for GET /books
  describe 'GET /books' do
    context 'when missing Authentication header' do
      before { get end_point }
      it_should_behave_like 'secured'
    end

    context 'when authorized' do
      # Make HTTP request before each example
      before { get end_point, headers: authorization_header }

      it 'returns books' do
        expect(json).not_to be_empty
        expect(json.length).to eq(5)
      end

      it 'returns status code 200(:ok)' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # Test suite for GET /books/:id
  describe 'GET /books/:id' do
    context 'when missing Authentication header' do
      before { get end_point_with_valid_id }
      it_should_behave_like 'secured'
    end

    context 'when authorized' do
      context 'when the book is found' do
        before { get end_point_with_valid_id, headers: authorization_header }

        it 'returns the book' do
          expect(json['id']).to eq(book_id)
          expect(json['category']).not_to be_empty
        end

        it 'returns status code 200(:ok)' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when the book is not found' do
        before { get end_point_with_invalid_id, headers: authorization_header }

        it 'returns status code 404(:not_found)' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  # Test suite for POST /books
  describe 'POST /books' do
    context 'when missing Authentication header' do
      before { post end_point }
      it_should_behave_like 'secured'
    end

    context 'when authorized' do
      context 'when the request is valid' do
        let!(:a_category) { create(:category) }
        let(:valid_params) { { title: 'Iliada', author: 'Homero', category_id: a_category.id } }
        before { post end_point, headers: authorization_header , params: valid_params }

        it 'returns status code 201(:created)' do
          expect(response).to have_http_status(:created)
        end

        it 'creates the book' do
          expect(json['id']).not_to be_nil
          expect(json['title']).to eq('Iliada')
          expect(json['author']).to eq('Homero')
          expect(json['category']).not_to be_empty
        end
      end

      context 'when the request is invalid' do
        let(:invalid_params) { { title: '', author: '' } }
        before { post end_point, headers: authorization_header , params: invalid_params }

        it 'returns status code 422(:unprocessable_entity)' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns a validation failed message' do
          expect(json['error']).to include('Validation failed')
          expect(json['error']).to include('Category must exist')
          expect(json['error']).to include("Title can't be blank")
          expect(json['error']).to include("Author can't be blank")
        end
      end
    end
  end

  # Test suite for PUT /books/:id
  describe 'PUT /book/:id' do
    context 'when missing Authentication header' do
      before { get end_point }
      it_should_behave_like 'secured'
    end

    context 'when authorized' do
      context 'when params are sent' do
        before { put end_point_with_valid_id, headers: authorization_header, params: { 'title' => 'New title' } }

        it 'returns status code 200(:ok)' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns the updated book' do
          expect(json['title']).to eq('New title')
        end
      end

      context 'when params are missing' do
        before { put end_point_with_valid_id, headers: authorization_header}

        it 'returns status code 204(:no_content)' do
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  # Test suite for DELETE /books/:id
  describe 'DELETE /books/:id' do
    context 'when missing Authentication header' do
      before { delete end_point_with_valid_id }
      it_should_behave_like 'secured'
    end

    context 'when authorized' do
      context 'when the book is found' do
        before { delete end_point_with_valid_id, headers: authorization_header }

        it 'deletes the book' do
          expect(Book.where(id: book_id)).to be_empty
        end

        it 'returns status code 204(:no_content)' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when the book is not found' do
        before { delete end_point_with_invalid_id, headers: authorization_header }

        it 'returns status code 404(:not_found)' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
