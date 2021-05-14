RSpec.describe HikOpenapi do
  before(:all) do
    @client = HikOpenapi::Client.new do |config|
      config.host = 'https://192.168.3.230'
      config.prefix = '/artemis'
      config.app_key = '<app_key>'
      config.app_secret = '<app_secret>'
      config.proxy = {host: '127.0.0.1', port: 8123} # If need to use a proxy
    end
  end

  it 'Has a version number' do
    expect(HikOpenapi::VERSION).not_to be nil
  end

  it 'test preview url' do
    params = {
      'cameraIndexCode': '<cameraIndexCode>',
      'streamType': 1,
      'protocol': 'rtmp',
      'transmode': 0,
      'expand': 'transcode=0',
    }

    res = @client.post('/api/video/v1/cameras/previewURLs', params)
    url = res.dig(:body, :data, :url)

    expect(url).not_to be nil
  end
end
