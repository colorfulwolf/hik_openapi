module HikOpenapi
  module REST
    # Infovision IoT
    # refs: https://open.hikvision.com/docs/659fb92a7ce13c465e97fb9f894fc3f6

    # 获取监控点预览取流URL
    PREVIEW = '/api/video/v1/cameras/previewURLs'.freeze
    # 分页获取监控点资源
    ALL_CAMERAS = '/api/resource/v1/cameras'.freeze
    # 根据监控点编号进行云台操作
    CONTROL = '/api/video/v1/ptzs/controlling'.freeze
    # 获取监控点回放取流URL
    PLAYBACK = '/api/video/v1/cameras/playbackURLs'.freeze
    # 根据监控点列表查询录像完整性结果
    RECORD_LIST = '/api/nms/v1/record/list'.freeze
    # 根据监控点列表查询视频质量诊断结果
    VQD_LIST = '/api/nms/v1/vqd/list'.freeze
    # 获取所有树编码
    ALLTREECODE = '/api/resource/v1/unit/getAllTreeCode'.freeze
    # 分页获取区域列表
    REGIONS = '/api/resource/v1/regions'.freeze
    # 获取根区域信息
    REGIONS_ROOT = ' /api/resource/v1/regions/root'.freeze
    # 根据区域编号获取下一级区域列表
    REGIONS_SUB = '/api/resource/v1/regions/subRegions'.freeze
    # 修改监控点经纬度
    MODIFY_CAMERA = '/api/resource/v1/camera/modifyCameraOperationResource'.freeze
  end
end
