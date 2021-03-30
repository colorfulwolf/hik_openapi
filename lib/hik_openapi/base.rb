require 'memoizable'

module HikOpenapi
  class Base
    include Memoizable

    attr_reader :attrs
    alias to_h attrs
    alias to_hash to_h

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [HikOpenapi::Base]
    def initialize(attrs = {})
      @attrs = attrs || {}
    end

    class << self
      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      def define_attribute_method(key1, klass = nil, key2 = nil)
        define_method(key1) do
          if attr_falsey_or_empty?(key1)
            NullObject.new
          else
            klass.nil? ? @attrs[key1] : HikOpenapi.const_get(klass).new(attrs_for_object(key1, key2))
          end
        end
        memoize(key1)
      end

      def define_predicate_method(key1, key2 = key1)
        define_method(:"#{key1}?") do
          !attr_falsey_or_empty?(key2)
        end
        memoize(:"#{key1}?")
      end
    end

  private

    def attr_falsey_or_empty?(key)
      !@attrs[key] || @attrs[key].respond_to?(:empty?) && @attrs[key].empty?
    end

    def attrs_for_object(key1, key2 = nil)
      if key2.nil?
        @attrs[key1]
      else
        attrs = @attrs.dup
        attrs.delete(key1).merge(key2 => attrs)
      end
    end
  end
end
