# frozen_string_literal: true

require 'hik_openapi/version'
require 'securerandom'
require 'openssl'
require 'http'

module HikOpenapi
  class Client
    attr_accessor :host, :prefix, :app_key, :app_secret, :proxy, :timeouts
    attr_writer :user_agent

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def get(path, params)
      request(:get, path, params)
    end

    def post(path, params)
      request(:post, path, params)
    end

    private

    def request(request_method, path, params)
      @uri = host + prefix + path
      @request_method = request_method
      @path = path
      @params = params
      @options_key = {get: :params, post: :json}[request_method] || :form
      @headers = {'Content-Type': 'application/json', 'Accept': '*/*', 'x-ca-timestamp': (Time.now.to_f * 1000).to_i.to_s, 'x-ca-nonce': SecureRandom.uuid, 'x-ca-key': app_key}
      perform
    end

    def perform
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http_client.headers(sign_headers(@headers)).public_send(@request_method, @uri.to_s, request_options.merge(ssl_context: ctx))
      response_body = response.body.empty? ? '' : symbolize_keys!(response.parse)
      response_headers = response.headers
      {
        headers: response_headers,
        body: response_body,
      }
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
      (%i[write connect read] - (timeouts&.keys || [])).empty?
    end

    def http_client
      client = proxy ? HTTP.via(*proxy.values_at(:host, :port, :username, :password).compact) : HTTP
      client = client.timeout(connect: timeouts[:connect], read: timeouts[:read], write: timeouts[:write]) if timeout_keys_defined
      client
    end

    def request_options
      {@options_key => @params}
    end

    def sign_headers(headers)
      headers.merge!({
                       "x-ca-signature": sign(@request_method, (prefix + @path), headers),
                     })
    end

    def sign(method, path, headers)
      sign_str = headers.reject { |a| a.to_s.start_with?('x-ca') }.values.sort
      sign_str = sign_str.unshift(method.to_s.upcase).push(path).join("\n")

      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          app_secret,
          sign_str
        )
      ).strip
    end
  end
end
