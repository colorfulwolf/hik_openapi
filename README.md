## Usage

```ruby
@client = HikOpenapi::Client.new do |config|
  config.host = "https://192.168.3.230"
  config.prefix = "/artemis"
  config.app_key = "app_key"
  config.app_secret = "app_secret"
  config.proxy = { host: "127.0.0.1", port: 8123 } if Rails.env.development?
end

params = {
  'cameraIndexCode': [url],
  'streamType':      0,
  'protocol':        [video_type],
  'transmode':       0,
  'expand':          "transcode=0",
}

res = @client.post("/api/video/v1/cameras/previewURLs", params)

```
