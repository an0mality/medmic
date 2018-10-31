source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'tiny_tds'
gem 'activerecord-sqlserver-adapter'
gem 'dbf'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'haml-rails', '~> 0.9'
gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'font-awesome-rails'

gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch =>'master'
gem 'best_in_place', '~> 3.0.1'

gem 'exception_notification'
gem 'simple_form'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'paperclip'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'kaminari'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'roo'
gem 'roo-xls'
gem 'rails-jquery-autocomplete'

gem 'mina'
gem 'mina-multistage', require: false
gem 'mina-whenever'
gem 'whenever' , require:  false
gem 'chart-js-rails'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_bot_rails'
  gem 'factory_bot'
  gem 'rails-controller-testing'
  gem 'cucumber-rails', :require => false
  # gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'guard-rspec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors', git: 'https://github.com/charliesome/better_errors.git', branch: 'master'
  gem 'binding_of_caller'
  gem 'rack-mini-profiler'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
