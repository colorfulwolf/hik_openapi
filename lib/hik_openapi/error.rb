module HikOpenapi
  class Error < StandardError
    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [Integer]
    # @return [HikOpenapi::Error]
    def initialize(message = '', code = nil)
      super(message)
      @code = code
    end

    attr_reader :code

    ClientError = Class.new(self)

    # Raised when returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    # Raised when returns the HTTP status code 401
    Unauthorized = Class.new(ClientError)

    # Raised when returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when returns the HTTP status code 413
    RequestEntityTooLarge = Class.new(ClientError)

    # Raised when returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when returns a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised when returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised when returns the HTTP status code 502
    BadGateway = Class.new(ServerError)

    # Raised when returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    # Raised when returns the HTTP status code 504
    GatewayTimeout = Class.new(ServerError)

    # Raised when operation subject to timeout takes too long
    TimeoutError = Class.new(self)

    ERRORS = {
      400 => HikOpenapi::Error::BadRequest,
      401 => HikOpenapi::Error::Unauthorized,
      403 => HikOpenapi::Error::Forbidden,
      404 => HikOpenapi::Error::NotFound,
      406 => HikOpenapi::Error::NotAcceptable,
      413 => HikOpenapi::Error::RequestEntityTooLarge,
      422 => HikOpenapi::Error::UnprocessableEntity,
      429 => HikOpenapi::Error::TooManyRequests,
      500 => HikOpenapi::Error::InternalServerError,
      502 => HikOpenapi::Error::BadGateway,
      503 => HikOpenapi::Error::ServiceUnavailable,
      504 => HikOpenapi::Error::GatewayTimeout,
    }.freeze

    class << self
      # Create a new error from an HTTP response
      #
      # @param body [String]
      # @param headers [Hash]
      # @return [HikOpenapi::Error]
      def from_response(body, headers)
        message, code = parse_error(body)
        new(message, headers, code)
      end

    private

      def parse_error(body)
        if body.nil? || body.empty?
          ['', nil]
        elsif body[:error]
          [body[:error], nil]
        elsif body[:errors]
          extract_message_from_errors(body)
        end
      end

      def extract_message_from_errors(body)
        first = Array(body[:errors]).first
        if first.is_a?(Hash)
          [first[:message].chomp, first[:code]]
        else
          [first.chomp, nil]
        end
      end
    end
  end
end
