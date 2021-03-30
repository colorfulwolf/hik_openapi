require 'http'
require 'json'
require 'openssl'

require 'hik_openapi/error'

module HikOpenapi
  module REST
    class Request
      attr_accessor :client, :headers, :options, :path, :rate_limit, :request_method, :uri

      def initialize(client, request_method, path, options = {}, params = nil)
        @client = client
        @uri = client.host + client.prefix + path
        @request_method = request_method
        @path = path
        @options = options
        @options_key = {get: :params, post: :json}[request_method] || :form
        @params = params
        @headers = {'Content-Type': 'application/json', 'Accept': '*/*',
                    'x-ca-timestamp': (Time.now.to_f * 1000).to_i.to_s, 'x-ca-nonce': SecureRandom.uuid, 'x-ca-key': client.app_key}
      end

      def perform
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http_client.headers(sign_headers(@headers)).public_send(@request_method, @uri.to_s, request_options.merge(ssl_context: ctx))
        response_body = response.body.empty? ? '' : symbolize_keys!(response.parse)
        response_headers = response.headers
        fail_or_return_response_body(response.code, response_body, response_headers)
      end

    private

      def request_options
        options = {@options_key => @options}
        if @params
          if options[:params]
            options[:params].merge(@params)
          else
            options[:params] = @params
          end
        end
        options
      end

      def sign_headers(headers)
        headers.merge!({
                         "x-ca-signature": sign(@request_method, (@client.prefix + @path), headers),
                       })
      end

      def sign(method, path, headers)
        sign_str = headers.reject { |a| a.to_s.start_with?('x-ca') }.values.sort
        sign_str = sign_str.unshift(method.to_s.upcase).push(path).join("\n")

        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha256'),
            @client.app_secret,
            sign_str
          )
        ).strip
      end

      def fail_or_return_response_body(code, body, headers)
        error = error(code, body, headers)
        raise(error) if error

        body
      end

      def error(code, body, headers)
        klass = HikOpenapi::Error::ERRORS[code]
        if klass == HikOpenapi::Error::Forbidden
          forbidden_error(body, headers)
        elsif !klass.nil?
          klass.from_response(body, headers)
          # elsif body&.is_a?(Hash) && (err = body.dig(:processing_info, :error))
          #   HikOpenapi::Error::MediaError.from_processing_response(err, headers)
        end
      end

      def forbidden_error(body, headers)
        error = HikOpenapi::Error::Forbidden.from_response(body, headers)
        klass = HikOpenapi::Error::FORBIDDEN_MESSAGES[error.message]
        if klass
          klass.from_response(body, headers)
        else
          error
        end
      end

      def symbolize_keys!(object)
        case object
        when Array
          object.each_with_index { |val, index| object[index] = symbolize_keys!(val) }
        when Hash
          object.dup.each_key { |key| object[key.to_sym] = symbolize_keys!(object.delete(key)) }
        end
        object
      end

      def timeout_keys_defined
        (%i[write connect read] - (@client.timeouts&.keys || [])).empty?
      end

      def http_client
        client = @client.proxy ? HTTP.via(*proxy) : HTTP
        client = client.timeout(connect: @client.timeouts[:connect], read: @client.timeouts[:read], write: @client.timeouts[:write]) if timeout_keys_defined
        client
      end

      def proxy
        @client.proxy.values_at(:host, :port, :username, :password).compact
      end
    end
  end
end
