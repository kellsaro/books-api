require 'rails_helper'

RSpec.describe "Books", type: :request do
  # Initialize test data
  let!(:books) { create_list(:book, 5) }
  let(:book_id) { books.first.id }
  let(:end_point) { '/api/v1/books' }
  let(:end_point_with_valid_id) { end_point.concat("/#{book_id}") }
  let(:end_point_with_invalid_id) { end_point.concat("/invalid_book_id") }
  
  # Test suite for GET /books
  describe 'GET /books' do
    # Make HTTP request before each example
    before { get end_point }

    it 'returns books' do
      expect(json).not_to be_empty
      expect(json.length).to eq(5)
    end 

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /books/:id
  describe 'GET /books/:id' do
    context 'when the book is found' do
      before { get end_point_with_valid_id }

      it 'returns the book' do
        expect(json['id']).to eq(book_id)
        expect(json['category']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the book is not found' do
      before { get end_point_with_invalid_id }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for POST /books
  describe 'POST /books' do
    context 'when the request is valid' do
      let(:valid_params) { { title: 'Iliada', author: 'Homero', category_id: Category.first.id } }
      before { post end_point, params: valid_params }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
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
      before { post end_point, params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failed message' do
        expect(json['error']).to include('Validation failed')
        expect(json['error']).to include('Category must exist')
        expect(json['error']).to include("Title can't be blank")
        expect(json['error']).to include("Author can't be blank")
      end
    end
  end

  # Test suite for DELETE /books/:id
  describe 'DELETE /books/:id' do
    context 'when the book is found' do
      before { delete end_point_with_valid_id }

      it 'deletes the book' do
        expect(Book.where(id: book_id)).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the book is not found' do
      before { delete end_point_with_invalid_id }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
