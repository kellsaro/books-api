module Api
  module V1
    class BooksController < ApplicationController
      before_action :authenticate_request!
      before_action :set_book, only: %i[show update destroy]

      # GET /books
      def index
        @books = Book.all
      end

      # GET /books/:id
      def show
      end

      # POST /books
      def create
        @book = current_user!.books.create(book_params)
        @book.save!
        render status: :created
      end

      # PUT /books
      def update
        status = :ok
        status = :no_content if book_params.empty?
        @book.update!(book_params) unless book_params.empty?

        render status: status
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
