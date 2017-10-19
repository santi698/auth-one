# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auth_one/version'

Gem::Specification.new do |spec|
  spec.name          = 'auth_one'
  spec.version       = AuthOne::VERSION
  spec.authors       = ['Santiago Ocamica']
  spec.email         = ['santi6982@gmail.com']

  spec.summary       = 'A pluggable authentication engine'
  spec.homepage      = 'https://github.com/santi698/auth_one'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bcrypt', '~> 3.1.11'
  spec.add_dependency 'jwt', '~> 2.1.0'
  spec.add_dependency 'sequel', '~> 5.0'
  spec.add_dependency 'sinatra', '~> 2.0.0'
  spec.add_dependency 'sinatra-contrib', '~> 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'puma', '~> 3.7'
  spec.add_development_dependency 'rack-test', '~> 0.8.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'sqlite3'
end
