#【モクモクテーマ】モクモクすることを書く
* http://railsapps.github.com/

## もくもくの記録
### 今日できたこと
* [git講座](http://www.slideshare.net/naotokoshikawa/p4p20120408-12520711)をしました
* [Rails Tutorial for Devise with Mongoid](http://railsapps.github.com/tutorial-rails-mongoid-devise.html)
* [とりあえずmongoで動いているらしい](https://github.com/ppworks/rails3-mongoid-devise)

```
rvm --create ruby-1.9.3-p125@sendagayarb2012-05-14
```
```
echo rvm use ruby-1.9.3-p125@sendagayarb2012-05-14 > .rvmrc
```
```
gem install rails --no-ri --no-rdoc
brew install mongodb
```


```
If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/Cellar/mongodb/2.0.2-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

If this is an upgrade and you already have the homebrew.mxcl.mongodb.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
    cp /usr/local/Cellar/mongodb/2.0.2-x86_64/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

Or start it manually:
    mongod run --config /usr/local/Cellar/mongodb/2.0.2-x86_64/mongod.conf

The launchctl plist above expects the config file to be at /usr/local/etc/mongod.conf.
If this is a first install, you can copy one from /usr/local/Cellar/mongodb/2.0.2-x86_64/mongod.conf:
    cp /usr/local/Cellar/mongodb/2.0.2-x86_64/mongod.conf /usr/local/etc/mongod.conf
==> Summary
/usr/local/Cellar/mongodb/2.0.2-x86_64: 18 files, 121M, built in 28 seconds
```

```
rails new rails3-mongoid-devise -T -O
cd rails3-mongoid-devise
git init
git add .
git commit -m'first commit'
```

```
vim Gemfile
```

```
source 'https://rubygems.org'
gem 'rails', '3.2.3'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "rspec-rails", ">= 2.8.1", :group => [:development, :test]
gem "database_cleaner", ">= 0.7.1", :group => :test
gem "mongoid-rspec", ">= 1.4.4", :group => :test
gem "factory_girl_rails", ">= 1.6.0", :group => :test
gem "cucumber-rails", ">= 1.2.1", :group => :test
gem "capybara", ">= 1.1.2", :group => :test
gem "launchy", ">= 2.0.5", :group => :test
gem "bson_ext", ">= 1.3.1"
gem "mongoid", ">= 2.4.3"
gem "devise", ">= 2.0.0"
```
```
rails generate rspec:install
```

```
vim spec/spec_helper.rb
```

```
vim config/application.rb
```

```
class Application < Rails::Application

  config.generators do |g|
    g.view_specs false
    g.helper_specs false
  end
```

```
# config.fixture_path = "#{::Rails.root}/spec/fixtures"
# config.use_transactional_fixtures = true
```

```
vim spec/spec_helper.rb to add this:
```

```
RSpec.configure do |config|
  # Other things

  # Clean up the database
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
```

```
vim spec/support/mongoid.rb
```

```
RSpec.configure do |config|
  config.include Mongoid::Matchers
end
```

```
vim spec/support/devise.rb
```

```
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
```

```
rails generate cucumber:install --capybara --rspec --skip-database
```

```
vim features/support/env.rb
```

```
begin
  DatabaseCleaner.orm = 'mongoid'
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end
```

```
diff --git a/features/support/env.rb b/features/support/env.rb
index 29f204c..71371a0 100644
--- a/features/support/env.rb
+++ b/features/support/env.rb
@@ -32,7 +32,8 @@ ActionController::Base.allow_rescue = false
 # Remove/comment out the lines below if your app doesn't have a database.
 # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
 begin
-  DatabaseCleaner.strategy = :transaction
+  DatabaseCleaner.orm = 'mongoid'
+  DatabaseCleaner.strategy = :truncation
 rescue NameError
   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
 end
```

```
rails generate mongoid:config
```

```
vim config/environments/development.rb
```

```
diff --git a/config/environments/development.rb b/config/environments/development.rb
index 4be812d..577d83b 100644
--- a/config/environments/development.rb
+++ b/config/environments/development.rb
@@ -14,7 +14,14 @@ Rails3MongoidDevise::Application.configure do
   config.action_controller.perform_caching = false
 
   # Don't care if the mailer can't send
-  config.action_mailer.raise_delivery_errors = false
+  #  config.action_mailer.raise_delivery_errors = false
+  # ActionMailer Config
+  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
+  # A dummy setup for development - no deliveries, but logged
+  config.action_mailer.delivery_method = :smtp
+  config.action_mailer.perform_deliveries = false
+  config.action_mailer.raise_delivery_errors = true
+  config.action_mailer.default :charset => "utf-8"
 
   # Print deprecation notices to the Rails logger
   config.active_support.deprecation = :log
```

```
rails generate devise:install
```

```
rails generate devise User
```

```
vim config/initializers/devise.rb
```

```
diff --git a/config/initializers/devise.rb b/config/initializers/devise.rb
index 6340e3f..27d7ca6 100644
--- a/config/initializers/devise.rb
+++ b/config/initializers/devise.rb
@@ -205,7 +205,7 @@ Devise.setup do |config|
   # config.navigational_formats = ["*/*", :html]
 
   # The default HTTP method used to sign out a resource. Default is :delete.
-  config.sign_out_via = :delete
+  config.sign_out_via = Rails.env.test? ? :get : :delete
 
   # ==> OmniAuth
   # Add a new OmniAuth provider. Check the wiki for more information on setting
```

```
vim config/application.rb
```

```
diff --git a/config/application.rb b/config/application.rb
index 94796d9..a82da0c 100644
--- a/config/application.rb
+++ b/config/application.rb
@@ -47,7 +47,7 @@ module Rails3MongoidDevise
     config.encoding = "utf-8"
 
     # Configure sensitive parameters which will be filtered from the log file.
-    config.filter_parameters += [:password]
+    config.filter_parameters += [:password, :password_confirmation]
 
     # Use SQL instead of Active Record's schema dumper when creating the database.
     # This is necessary if your schema can't be completely dumped by the schema dumper,
```

* Customize the Application の手前まで


### 今日学んだこと

```config/application.rb```で

```
class Application < Rails::Application

  config.generators do |g|
    g.view_specs false
    g.helper_specs false
  end
```

とすると、scaffoldで生成されるspecを指定できる

```config/initializers/devise.rb```で以下のようにhttp method変えられる

```
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = Rails.env.test? ? :get : :delete
```

### 今日ハマったこと
* コレやります。
 $ pwd

## 個人のKPT
###Keep よかったー
* コレやります。

###Problem ダメだったー
* 
* コレやります。

###Try 改善・挑戦するー
* コレやります。


