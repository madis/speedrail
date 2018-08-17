route "root to: 'application#welcome'"
TEMPLATE_ROOT = File.dirname(__FILE__)

def templates(path)
  TEMPLATE_ROOT + "/#{path}"
end

gem 'sassc-rails'
gem 'bootstrap-sass'

gem_group :development, :test do
  gem 'factory_bot'
  gem 'spring-commands-rspec'
  gem 'rubocop', require: false
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers', require: false
  gem 'pry'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

gem_group :test do
  gem 'database_cleaner'
end

remove_file 'app/assets/stylesheets/application.css'
remove_file 'README.rdoc'

%w(spec_helper.rb rails_helper.rb factories.rb support/request_helpers.rb features/welcome_spec.rb).each do |path|
  full_path = "spec/#{path}"
  create_file full_path, File.read(templates(full_path))
end
create_file 'app/assets/stylesheets/application.scss',  File.read(templates('app/assets/stylesheets/application.scss'))

# Add configuration & dotfiles for various tools integration
Dir["#{templates('dotfiles')}/*"].each do |path|
  name = Pathname.new(path).basename
  create_file ".#{name}", File.read(path)
end

# Create postgres database for test & development
run "createdb #{app_path}_development"
run "createdb #{app_path}_test"
run "sed -i '' '1,54 s/username: #{app_path}/username: #{ENV['USER']}/' config/database.yml"

# Start new git repo with empty commit
git :init
git commit: %Q{--allow-empty -m 'Empty root commit'}

def create_github_repo(app_path)
  user, token = get_github_credentials
  create_repo_cmd = "curl -v -u '#{user}:#{token}' -X POST https://api.github.com/user/repos -d '{\"name\":\"#{app_path}\"}'"
  run create_repo_cmd
  git remote: "add origin git@github.com:#{ENV['GITHUB_USER']}/#{app_path}.git"
  git push: "origin master"
end

def get_github_credentials
  user, token = [ENV['GITHUB_USER'], ENV['GITHUB_TOKEN']]
  if user.nil? || token.nil?
    puts "Please set GITHUB_USER and GITHUB_TOKEN environment variables before running this script"
    puts "You can create one at https://github.com/settings/tokens/new"
    puts "Make them available using:"
    puts "  export GITHUB_USER=your-user GITHUB_TOKEN=your-token"
  else
    puts "Got the github credentials from ENV: user: #{user} token #{token.gsub(/./, '*')}"
    [user, token]
  end
end

after_bundle do
  create_github_repo(app_path) if yes?("Do you want to create github repo #{app_path} (y/n)?")
end

