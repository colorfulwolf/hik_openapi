module HikOpenapi
  class Camera < HikOpenapi::Base
    attr_reader :code, :msg, :data

    def url
      data[:url]
    end
  end
end
