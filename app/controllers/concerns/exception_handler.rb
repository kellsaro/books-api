module ExceptionHandler
  extend ActiveSupport::Concern

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ error: e.message }, :not_found)
    end
    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ error: e.message }, :unprocessable_entity)
    end
    rescue_from ActiveRecord::RecordNotDestroyed do |e|
      json_response({ errors: e.record.errors }, :unprocessable_entity)
    end
  end
end
