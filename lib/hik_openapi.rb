# frozen_string_literal: true

require 'hik_openapi/version'
require 'hik_openapi/configuration'

module HikOpenapi
  class Error < StandardError; end

  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config
    end

    def setup(&block)
      config.instance_exec(&block)
    end
  end
end
