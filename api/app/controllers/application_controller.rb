class ApplicationController < ActionController::API
  class BadRequestError < StandardError; end

  before_action :authenticate_api_key!

  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from BadRequestError, with: :render_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def authenticate_api_key!
    provided_api_key = request.headers["X-API-Key"].to_s
    expected_api_key = ENV.fetch("API_KEY", "development-api-key")

    return if api_key_valid?(provided_api_key, expected_api_key)

    render json: {
      error: "Unauthorized",
      details: ["A valid X-API-Key header is required"]
    }, status: :unauthorized
  end

  def api_key_valid?(provided_api_key, expected_api_key)
    return false if provided_api_key.blank? || expected_api_key.blank?
    return false unless provided_api_key.bytesize == expected_api_key.bytesize

    ActiveSupport::SecurityUtils.secure_compare(provided_api_key, expected_api_key)
  end

  def render_bad_request(error)
    render json: { error: "Bad request", details: [error.message] }, status: :bad_request
  end

  def render_not_found(error)
    render json: { error: "Resource not found", details: [error.message] }, status: :not_found
  end

  def render_validation_error(record)
    render json: { error: "Validation failed", errors: record.errors.full_messages }, status: :unprocessable_entity
  end

  def paginated_payload(scope)
    page, per_page = pagination_params
    total_count = scope.count

    {
      data: scope.offset((page - 1) * per_page).limit(per_page),
      pagination: {
        current_page: page,
        per_page: per_page,
        total_pages: (total_count.to_f / per_page).ceil,
        total_count: total_count
      }
    }
  end

  def pagination_params
    page = positive_integer_param(:page, 1)
    per_page = [positive_integer_param(:per_page, 10), 50].min

    [page, per_page]
  end

  def positive_integer_param(name, default)
    raw_value = params[name]
    return default if raw_value.blank?

    parsed_value = Integer(raw_value, 10)
    raise BadRequestError, "#{name} must be a positive integer" if parsed_value <= 0

    parsed_value
  rescue ArgumentError, TypeError
    raise BadRequestError, "#{name} must be a positive integer"
  end
end
