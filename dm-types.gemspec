# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-types/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = [ 'Dan Kubb' ]
  gem.email       = [ 'dan.kubb@gmail.com' ]
  gem.summary     = 'DataMapper plugin providing extra data types'
  gem.description = gem.summary
  gem.homepage    = 'http://datamapper.org'

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.rdoc]

  gem.name          = 'dm-types'
  gem.require_paths = %w[lib]
  gem.version       = DataMapper::Types::VERSION

  gem.add_runtime_dependency('bcrypt',      '~> 3.0')
  gem.add_runtime_dependency('dm-core',     '~> 1.3.0.beta')
  gem.add_runtime_dependency('fastercsv',   '~> 1.5.4')
  gem.add_runtime_dependency('multi_json', '~> 1.3.2')
  gem.add_runtime_dependency('stringex', '>= 2.0.8')
  gem.add_runtime_dependency('safe_yaml',   '~> 0.6.1')
  gem.add_runtime_dependency('uuidtools',   '~> 2.1.2')

  gem.add_development_dependency('rake',  '~> 0.9.2')
  gem.add_development_dependency('rspec', '~> 1.3.2')
end
