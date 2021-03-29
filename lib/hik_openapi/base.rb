module HikOpenapi
  class Base
    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [HikOpenapi::Base]
    def initialize(attrs = {})
      @attrs = attrs || {}
    end
  end
end
