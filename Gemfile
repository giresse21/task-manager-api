source "https://rubygems.org"

ruby "3.2.2"

# Core Rails
gem "rails", "~> 8.1.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Authentification JWT
gem "bcrypt", "~> 3.1.7"
gem "jwt"

# CORS pour frontend
gem "rack-cors"

# Pagination
gem "kaminari"

# Serialization JSON
gem "active_model_serializers"

# Performance
gem "bootsnap", require: false

# Deploy (optionnel pour ce projet)
gem "solid_cache"
gem "solid_queue"

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  
  # Tests RSpec
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "database_cleaner-active_record"
  
  # Code quality
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "bundler-audit", require: false
end

group :development do
  # Variables d'environnement
  gem "dotenv-rails"
end