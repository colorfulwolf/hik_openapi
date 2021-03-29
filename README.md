## Usage

```ruby
@client = HikOpenapi::REST::Client.new do |config|
  config.host = 'https://192.168.1.2'
  config.prefix = '/artemis'
  config.app_key = '1234'
  config.app_secret = 'asdf'
  config.proxy = {host: '127.1', port: 8123}
end
```
