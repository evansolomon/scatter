# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'scatter'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'thor', '~> 0.17.0'
  spec.authors = ['Evan Solomon']
  spec.email = 'evan@evanalyze.com'
  spec.description = "A deploy helper."
  spec.executables = %w(scatter)
  spec.files = %w(README.md scatter.gemspec MIT-LICENSE)
  spec.files += Dir.glob("bin/**/*")
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'http://evansolomon.me/'
  spec.licenses = ['MIT']
  spec.name = 'scatter_deploy'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.6'
  spec.summary = "Scatter separates deploy scripts from project code, but keeps the convenience of running deploys from project directories."
  spec.version = Scatter::VERSION
end
