require 'spec_helper'

RSpec.describe HikOpenapi::REST::Client do
  before do
    @client = HikOpenapi::REST::Client.new do |config|
      # config.host = 'https://127.1'
      config.host = 'https://191.136.6.2'
      config.prefix = '/artemis'
      config.app_key = '29198772'
      config.app_secret = 'DU23r7XFovCyI1DQz6yw'
      config.proxy = {host: '127.1', port: 8123}
    end
  end
  it 'client initialize' do
    expect(@client).not_to be nil
  end
  it 'camera list' do
    res = @client.preview('0c908187618d4c6fa21b61ee71465581')
    puts res
    puts res.body
    puts res.parse
    expect(res).not_to be nil
  end
end
