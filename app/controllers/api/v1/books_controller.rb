module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[show destroy]

      def index
        @books = Book.all
      end

      def show; end
      
      def create
        @book = Book.new(book_params)
        @book.save!
        render status: :created
      end

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
