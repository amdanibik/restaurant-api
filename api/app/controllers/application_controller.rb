class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_bad_request(error)
    render json: { error: "Bad request", details: [error.message] }, status: :bad_request
  end

  def render_not_found(error)
    render json: { error: "Resource not found", details: [error.message] }, status: :not_found
  end

  def render_validation_error(record)
    render json: { error: "Validation failed", errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
