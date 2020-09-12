# frozen_string_literal: true

require 'hik_openapi/version'
require 'hik_openapi/configuration'
require 'hik_openapi/api'
require 'hik_openapi/result'

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
