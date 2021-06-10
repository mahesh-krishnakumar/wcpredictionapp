ruby '2.7.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'

gem 'dotenv-rails', '~> 2.2', groups: %i[development test]

gem 'activeadmin', '~> 2.6.0'
gem 'active_admin_datetimepicker'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'devise'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
#
gem 'jquery-rails' #Required by bootstrap
gem 'bootstrap', '~> 4.3.1'
gem 'font-awesome-rails'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# HTML Slim
gem 'slim'

# A simple gem to group by day, week etc.
gem 'groupdate'

# For seeding both in dev and production.
gem 'seedbank'

# Slick, a jQuery plugin for cool carousels.
gem 'jquery-slick-rails'

# Skylight agent for Ruby
gem 'skylight'

# Exception tracking and logging from Ruby to Rollbar
gem 'rollbar'

# Rails form builder using Bootstrap 4
gem 'bootstrap_form'

# Rails engine for cache-friendly, client-side local time
gem 'local_time'

group :production do
  gem 'google-cloud-storage', '~> 1.8', require: false
end
