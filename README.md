## Usage

```ruby
@client = HikOpenapi::REST::Client.new do |config|
  config.host = 'https://192.168.1.2'
  config.prefix = '/artemis'
  config.app_key = '1234'
  config.app_secret = 'asdf'
  config.proxy = {host: '127.1', port: 8123}
end

@client.preview('0c908187618d4c6fa21b61ee71465581')
@client.preview('0c908187618d4c6fa21b61ee71465581', 0, 'rtmp', 0, '')

OR

request = @client.post("/api/video/v1/cameras/previewURLs",{
    "cameraIndexCode": "0c908187618d4c6fa21b61ee71465581",
    'streamType': 0,
    'protocol': 'rtmp',
    'transmode': 0,
    'expand': 'transcode=0'
})
result = request.perform
```

REPL `require 'hik_openapi/rest/client'`