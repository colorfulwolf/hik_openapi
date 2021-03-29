# require 'hik_openapi/list'
require 'hik_openapi/base'
require 'hik_openapi/camera'
require 'hik_openapi/rest/constant'
require 'hik_openapi/rest/utils'

module HikOpenapi
  module REST
    module Lists
      include HikOpenapi::REST::Utils

      # @param cameraIndexCode [String] 监控点编号（通用唯一识别码UUID）
      # @param streamType [String] 码流类型(0-主码流,1-子码流),未填默认为主码流
      # @param protocol [String] 此字段未指定默认为rtsp协议. rtsp/rmtp/hls
      # @param transmode [String] 协议类型( 0-udp，1-tcp)
      # @param expand [Array] 此字段非必要不建议指定, refs: https://open.hikvision.com/docs/659fb92a7ce13c465e97fb9f894fc3f6
      # @return [Array<HikOpenapi::Camera>]
      def preview(camera_index_code, stream_type = 0, protocol = 'rtsp', transmode = 0, expand = 'transcode=0')
        objects_from_response(HikOpenapi::Camera, :post, ::HikOpenapi::REST::PREVIEW, {
                                cameraIndexCode: camera_index_code,
                                streamType: stream_type,
                                protocol: protocol,
                                transmode: transmode,
                                expand: expand,
                              })
      end
    end
  end
end
