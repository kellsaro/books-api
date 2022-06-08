module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :destroy]

      # GET /categories
      def index
        @categories = Category.all
      end

      # GET /categories/:id
      def show; end

      # POST /categories
      def create
        @category = Category.create(category_params)
        @category.save!
        render status: :created
      end

      # DELETE /categories/:id
      def destroy
        @category.destroy!
        head :no_content
      end

      private

      def category_params
        params.permit(:name)
      end

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
end
