# Encoding: UTF-8

source 'https://rubygems.org'

group :development do
  gem 'yard-chef'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-kitchen'
  gem 'listen', '~> 3.0.7'
end

group :test do
  gem 'rake'
  gem 'rubocop'
  gem 'foodcritic'
  gem 'rspec'
  gem 'chefspec'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'test-kitchen'
  gem 'kitchen-localhost'
  gem 'kitchen-vagrant'
  gem 'winrm-transport'
end

group :integration do
  gem 'serverspec'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'chef', '>= 11'
  gem 'berkshelf'
end
