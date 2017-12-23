require 'redis'
rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'

if Rails.env.production?
  resque_config = YAML.load_file(rails_root + '/config/redis.yml')
  Resque.redis = Redis.new(resque_config[:resque])
end