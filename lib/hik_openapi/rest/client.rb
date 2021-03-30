require 'hik_openapi/rest/api'

module HikOpenapi
  module REST
    class Client
      include HikOpenapi::REST::API
      attr_accessor :host, :prefix, :app_key, :app_secret, :proxy, :timeouts
      attr_writer :user_agent

      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        yield(self) if block_given?
      end

      def get(path, params)
        ::HikOpenapi::REST::Request.new(self, :get, path, params)
      end

      def post(path, params)
        ::HikOpenapi::REST::Request.new(self, :post, path, params)
      end
    end
  end
end
