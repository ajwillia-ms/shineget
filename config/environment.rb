# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Shineget::Application.initialize!

PriceWorker.new.schedule
SyncWorker.new.schedule