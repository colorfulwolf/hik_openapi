# frozen_string_literal: true

require 'hik_openapi/version'
require 'hik_openapi/configuration'
require 'hik_openapi/result'

require 'hik_openapi/rest/api'
require 'hik_openapi/rest/client'
require 'hik_openapi/api'

module HikOpenapi
  class Error < StandardError; end

  def self.config
    return @config if defined?(@config)

    @config = Configuration.new
    @config
  end

  def self.setup
    yield config
  end

  def self.api
    Api
  end
end
