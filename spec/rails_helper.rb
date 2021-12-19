# ENV['RAILS_ENV'] ||= 'test'
# # Prevent database truncation if the environment is production
# abort("The Rails environment is running in production mode!") if Rails.env.production?

# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   exit 1
# end

require 'database_cleaner'
require 'spec_helper'
# require File.expand_path('../config/environment', __dir__)
# Dir[RAILS.root.join('spec/support/**/*.rb')].each { |f| require f }


RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
  # config.infer_spec_type_from_file_location!
  # # Filter lines from Rails gems in backtraces.
  # config.filter_rails_from_backtrace!
   
  config.include RequestSpecHelper, type: :request

  # Add `FactoryBot` methods
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do 
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end 
  
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do 
      example.run
    end 
  end 

end

Shoulda::Matchers.configure  do |config|
  config.integrate do |with|
    with.test_framework :rspec 
    with.library :rails 
  end 
end 
