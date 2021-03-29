require 'hik_openapi/rest/request'
module HikOpenapi
  module REST
    module Utils
    private

      def perform_get(path, options = {})
        perform_request(:get, path, options)
      end

      def perform_post(path, options = {})
        perform_request(:post, path, options)
      end

      def perform_request(request_method, path, options = {}, params = nil)
        HikOpenapi::REST::Request.new(self, request_method, path, options, params).perform
      end

      def perform_request_with_object(request_method, path, options, klass, params = nil)
        response = perform_request(request_method, path, options, params)
        klass.new(response)
      end

      def objects_from_response(klass, request_method, path, params)
        perform_request_with_object(request_method, path, params, klass)
      end

      def perform_get_with_object(path, options, klass)
        perform_request_with_object(:get, path, options, klass)
      end

      def perform_post_with_object(path, options, klass)
        perform_request_with_object(:post, path, options, klass)
      end
    end
  end
end
