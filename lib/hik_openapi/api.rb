# frozen_string_literal: true

require 'securerandom'

module HikOpenapi
  class Api
    def self.get
      # TODO
      puts 'WIP'
    end

    def self.post(path, body)
      uri = URI(HikOpenapi.config.host)
      uri.merge!(path)

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      headers.transform_values! { |v| v.force_encoding('iso-8859-1') }
      headers = init_header('POST', uri.path)

      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = body.to_json
      res = https.request(request)
      {
        code: res.code,
        body: res.body.force_encoding('utf-8'),
        response: res
      }
    end

    private

    def init_header(method, path)
      headers = {
        'Content-Type': 'application/json',
        "Accept": '*/*',
        'x-ca-timestamp': (Time.now.to_f * 1000).to_i.to_s,
        'x-ca-nonce': SecureRandom.uuid,
        'x-ca-key': appKey
      }

      headers.merge({
                      "x-ca-signature": SignUtil.sign(method, path, headers)
                    })
    end

    def sign(method, path, headers)
      sign_str = headers.reject { |a| a.to_s.start_with?('x-ca') }.values.sort
      sign_str = sign_str.unshift(method).push(path).join("\n")

      enc = Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          HikOpenapi.config.app_secret,
          sign_str
        )
      ).strip
      enc
    end
  end
end
