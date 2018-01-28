source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'webpacker', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'

gem 'config'
gem 'devise', '~> 4.4.0'
gem 'hashid-rails', '~> 1.0'
gem 'search_cop'

gem 'inky-rb', require: 'inky'
gem 'premailer-rails'

gem 'simple_form'
gem 'mailboxer'

gem 'kaminari'

gem 'pdfkit'
gem 'gocardless_pro'

group :production do
  gem 'pg'
  gem 'redis-rails'
  gem 'resque'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'yard'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]