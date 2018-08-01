# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'timetrap_everhour/version'

Gem::Specification.new do |s|
  s.name = 'timetrap_everhour'
  s.version = TimetrapEverhour::VERSION
  s.date = '2018-07-31'
  s.summary = 'timetrap + everhour'
  s.description = 'Everhour integration for timetrap'
  s.authors = ['Jorge Morante']
  s.email = 'jorge@morante.eu'
  s.files = Dir.glob('lib/**/*.rb')
  s.homepage = 'https://github.com/morantron/timetrap_everhour'
  s.license = 'MIT'

  s.add_dependency 'faraday', '~> 0.15', '>= 0.15.2'
  s.add_dependency 'faraday_middleware', '~> 0.12', '>= 0.12.2'
  s.add_dependency 'whirly', '~> 0.2', '>= 0.2.6'
  s.add_dependency 'paint', '~> 2.0', '>= 2.0.1'
  s.add_dependency 'time_diff', '~> 0.3', '>= 0.3.0'
  s.add_dependency 'highline', '~> 2.0', '>= 2.0.0'

  s.add_development_dependency 'rspec', '~> 3.0',  '>= 3.0.0'
  s.add_development_dependency 'pry',   '~> 0.10', '>= 0.10.0'

  s.add_runtime_dependency 'timetrap', '~> 1.7', '>= 1.7.0'
end
