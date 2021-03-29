# frozen_string_literal: true

require 'net/http'
require 'json'
require 'base64'
require 'uri'
require 'securerandom'
require 'openssl'

module HikOpenapi
  module Api
    class << self
      def get
        # TODO
        puts 'WIP'
      end

      def post(path, body)
        uri = URI(HikOpenapi.config.host)
        uri.merge!(path)

        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.open_timeout = 10
        https.read_timeout = 10
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        headers = init_header('POST', uri.path)
        # headers.transform_values! { |v| v.force_encoding('iso-8859-1') }

        begin
          request = Net::HTTP::Post.new(uri.request_uri, headers)
          request.body = body.to_json
          res = https.request(request)

          result = HikOpenapi::Result.new
          result.code = res.code
          result.body = JSON.parse(res.body.force_encoding('utf-8'))
          result.origin = res
          result
        rescue StandardError => e
          result = HikOpenapi::Result.new
          result.error = HikOpenapi::Error.new(e)
          result
        end
      end

    private

      def init_header(method, path)
        headers = {
          'Content-Type': 'application/json',
          "Accept": '*/*',
          'x-ca-timestamp': (Time.now.to_f * 1000).to_i.to_s,
          'x-ca-nonce': SecureRandom.uuid,
          'x-ca-key': HikOpenapi.config.app_key,
        }

        headers.merge({
                        "x-ca-signature": sign(method, path, headers),
                      })
      end

      def sign(method, path, headers)
        sign_str = headers.reject { |a| a.to_s.start_with?('x-ca') }.values.sort
        sign_str = sign_str.unshift(method).push(path).join("\n")

        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha256'),
            HikOpenapi.config.app_secret,
            sign_str
          )
        ).strip
      end
    end
  end
end
