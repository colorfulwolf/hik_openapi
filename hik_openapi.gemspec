require_relative 'lib/hik_openapi/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'http', '~> 4.4.1'

  spec.name          = 'hik_openapi'
  spec.version       = HikOpenapi::VERSION
  spec.authors       = ['palytoxin']
  spec.email         = ['sxty32@gmail.com']

  spec.summary       = 'hikvision openapi for ruby.'
  spec.description   = 'hikvision openapi for ruby.'
  spec.homepage      = 'https://github.com/palytoxin/hik_openapi'
  spec.licenses      = ['MIT']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/palytoxin/hik_openapi'
  spec.metadata['changelog_uri'] = 'https://github.com/palytoxin/hik_openapi'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
end
