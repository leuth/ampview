# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ampview/version'

Gem::Specification.new do |spec|
  spec.name          = 'ampview'
  spec.version       = Ampview::VERSION
  spec.authors       = ['leuth']
  spec.email         = ['ampview@example.com']

  spec.summary       = 'AMP(Accelerated Mobile Pages) view helpers for Ruby on Rails.'
  spec.description   = 'for pages of static, list, search results'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 5.1'
  spec.add_dependency 'fastimage', '~> 2.0'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
