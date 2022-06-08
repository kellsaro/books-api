module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[show destroy]

      # GET /books
      def index
        @books = Book.all
      end

      # GET /books/:id
      def show; end
      
      # POST /books
      def create
        @book = Book.new(book_params)
        @book.save!
        render status: :created
      end

      # DELETE /books/:id
      def destroy
        @book.destroy!
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.permit(:title, :author, :category_id)
      end
    end
  end
end
