route "root to: 'application#welcome'"
TEMPLATE_ROOT = File.dirname(__FILE__)

def templates(path)
  TEMPLATE_ROOT + "/#{path}"
end

gem 'sass-rails'
gem 'bootstrap-sass'

gem_group :development, :test do
  gem 'factory_girl'
  gem 'spring-commands-rspec'
  gem 'rubocop'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers', require: false
  gem 'pry'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

remove_file 'app/assets/stylesheets/application.css'
remove_file 'README.rdoc'

%w(spec_helper.rb rails_helper.rb factories.rb support/request_helpers.rb features/welcome_spec.rb).each do |path|
  full_path = "spec/#{path}"
  create_file full_path, File.read(templates(full_path))
end
create_file 'app/assets/stylesheets/application.scss',  File.read(templates('app/assets/stylesheets/application.scss'))

# Create postgres database for test & development
run "createdb #{app_path}_development"
run "createdb #{app_path}_test"
run "sed -i '' '1,54 s/username: #{app_path}/username: #{ENV['USER']}/' config/database.yml"

after_bundle do
  git :init
  git commit: %Q{--allow-empty -m 'Empty root commit'}
  auth = "#{ENV['GITHUB_USER']}:#{ENV['GITHUB_TOKEN']}"
  create_repo_cmd = "curl -v -u '#{auth}' -X POST https://api.github.com/user/repos -d '{\"name\":\"#{app_path}\"}'"
  run create_repo_cmd
  git remote: "add origin git@github.com:#{ENV['GITHUB_USER']}/#{app_path}.git"
  git push: "origin master"
end

