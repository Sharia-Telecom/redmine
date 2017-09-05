source 'https://rubygems.org'
ruby '2.3.4'
if Gem::Version.new(Bundler::VERSION) < Gem::Version.new('1.5.0')
  abort "Redmine requires Bundler 1.5.0 or higher (you're using #{Bundler::VERSION}).\nPlease update with 'gem update bundler'."
end

gem "rails", "4.2.8"
gem "addressable", "2.4.0" if RUBY_VERSION < "2.0"
gem "jquery-rails", "~> 3.1.4"
gem "coderay", "~> 1.1.1"
gem "request_store", "1.0.5"
gem "mime-types", (RUBY_VERSION >= "2.0" ? "~> 3.0" : "~> 2.99")
gem "protected_attributes"
gem "actionpack-xml_parser"
gem "roadie-rails", "~> 1.1.1"
gem "roadie", "~> 3.2.1"
gem "mimemagic"

gem "nokogiri", (RUBY_VERSION >= "2.1" ? "~> 1.7.2" : "~> 1.6.8")
gem "i18n", "~> 0.7.0"
gem "ffi", "1.9.14", :platforms => :mingw if RUBY_VERSION < "2.0"

# Request at least rails-html-sanitizer 1.0.3 because of security advisories
gem "rails-html-sanitizer", ">= 1.0.3"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => [:mri, :mingw, :x64_mingw, :mswin]
gem "rbpdf", "~> 1.19.2"

# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.12.0"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.3.0", :require => "openid"
  gem "rack-openid"
end

platforms :mri, :mingw, :x64_mingw do
  # Optional gem for exporting the gantt to a PNG file, not supported with jruby
  group :rmagick do
    gem "rmagick", ">= 2.14.0"
  end

  # Optional Markdown support, not for JRuby
  group :markdown do
    gem "redcarpet", "~> 3.4.0"
  end
end

# Include database gems for the adapters found in the database
# configuration file
require 'erb'
require 'yaml'
#database_file = File.join(File.dirname(__FILE__), "config/database.yml")
#if File.exist?(database_file)
#  database_config = YAML::load(ERB.new(IO.read(database_file)).result)
#  adapters = database_config.values.map {|c| c['adapter']}.compact.uniq
#  if adapters.any?
#    adapters.each do |adapter|
#      case adapter
#      when 'mysql2'
#        gem "mysql2", "~> 0.4.6", :platforms => [:mri, :mingw, :x64_mingw]
#      when /postgresql/
#        gem "pg", "~> 0.18.1", :platforms => [:mri, :mingw, :x64_mingw]
#      when /sqlite3/
#        gem "sqlite3", (RUBY_VERSION < "2.0" && RUBY_PLATFORM =~ /mingw/ ? "1.3.12" : "~>1.3.12"),
#                       :platforms => [:mri, :mingw, :x64_mingw]
#      when /sqlserver/
#        gem "tiny_tds", (RUBY_VERSION >= "2.0" ? "~> 1.0.5" : "~> 0.7.0"), :platforms => [:mri, :mingw, :x64_mingw]
#        gem "activerecord-sqlserver-adapter", :platforms => [:mri, :mingw, :x64_mingw]
#      else
#        warn("Unknown database adapter `#{adapter}` found in config/database.yml, use Gemfile.local to load your own database gems")
#      end
#    end
#  else
#    warn("No adapter found in config/database.yml, please configure it first")
#  end
#else
#  warn("Please configure your config/database.yml first")
#end
group :production do
# gems specifically for Heroku go here
gem "rails_12factor"
gem "pg", "~> 0.18.1", :platforms => [:mri, :mingw, :x64_mingw]
gem "puma"
gem "acts_as_list"
gem "svg-graph"
gem "redmine_crm"
gem "vcard", "~> 0.2.8"
gem "spreadsheet", "~> 0.6.8"
gem "rufus-scheduler", "3.0.3"
gem "write_xlsx"
if RUBY_VERSION > '1.9'
  gem "prawn", "~> 1.0.0"
else
  gem "pdf-reader", '<1.4.0'
  gem "prawn", "0.12.0"
end
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "deface", ">= 1.1.0"
gem "resort", "~> 0.5.0"
gem "haml", "~> 4.0.6"
gem "dropbox-api"
gem "holidays"
gem "roo"
gem "axlsx"
gem "axlsx_rails"
gem "dalli"
gem "memcachier"
gem "lockfile", "~> 2.1.3"
gem "money"
gem "jwt", "~> 1.5"
gem "active_model_otp"
gem "rqrcode"
gem "omniauth-google-oauth2", ">= 0.2.6"
gem "google-api-client", ">= 0.7.1"
gem "rest-client"
gem "activeresource"
gem "rich", git: "https://github.com/a-ono/rich.git"
gem "kaminari"
gem "htmlentities"
gem "paperclip", "~> 4.2.1"
gem "pandoc-ruby"
gem "sprockets-rails", "< 3.0.0"
gem "vpim", "13.11.11"
gem "redmine_extensions" unless Dir.exist?(File.expand_path('../../easyproject', __FILE__))
gem "fog", "1.36.0"
gem "haml-rails"
gem "require_patch", "~> 0.1.0"
gem "docile", "~> 1.1.0"
gem "json", "~> 1.8"
gem "httpclient"
gem "business_time", "0.7.6"
gem "rubyzip", ">= 1.0.0"
gem "zip-zip"
gem "simple_enum"
gem "uuidtools"
gem "dav4rack"
gem "deep_cloneable", "~> 2.2.2"
gem "whenever", :require => false
gem "pidfile", git: "https://github.com/arturtr/pidfile.git"
gem "sidekiq-failures", git: "https://github.com/mhfs/sidekiq-failures.git", branch: "master"
gem "sidekiq-cron"
gem "sidekiq-rate-limiter", git: "https://github.com/centosadmin/sidekiq-rate-limiter", branch: "master", :require => "sidekiq-rate-limiter/server"
gem "telegram-bot-ruby", "<= 0.7.2"
gem "sidekiq"
gem "sinatra", "~> 1.4"
gem "byebug"
gem "attr_encrypted"
gem "encryptor"
gem "gemoji", "~> 3.0.0"
gem "letter_opener", "~> 1.4.0"
gem "letter_opener_web", "~> 1.3.0"
end

group :xapian do
#gem "xapian-full-alaveteli", :require => false
end

group :development do
gem "rdoc", "~> 4.3"
gem "yard"
gem "sass", "~> 3.4.15"
gem "copyright-header", "~> 1.0.8"
gem "rubocop", :require => false
end

group :test do
gem "minitest"
gem "rails-dom-testing"
gem "mocha"
gem "simplecov", "~> 0.9.1", :require => false
gem "simplecov-html", "~> 0.10.0"
# TODO: remove this after upgrading to Rails 5
gem "test_after_commit", "~> 0.4.2"
# For running UI tests
gem "capybara"
gem "selenium-webdriver", "~> 2.53.4"
gem "simplecov-rcov"
gem "factory_girl_rails"
gem "shoulda"
gem "shoulda-matchers"
gem "coveralls", :require => false
gem "launchy"
gem "poltergeist"
gem "capybara-screenshot"
gem "timecop"
gem "vcr"
gem "webmock"
gem "fakeweb", "~> 1.3", :require => false
gem "factory_girl"
gem "codeclimate-test-reporter", :require => false
gem "rake", :require => false
gem "spy"
gem "database_cleaner", "1.5.1"
gem "minitest-around"
gem "minitest-reporters"
gem "brakeman"
end

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exists?(local_gemfile)
  eval_gemfile local_gemfile
end

# Load plugins' Gemfiles
Dir.glob File.expand_path("../plugins/*/{Gemfile,PluginGemfile}", __FILE__) do |file|
  eval_gemfile file
end
