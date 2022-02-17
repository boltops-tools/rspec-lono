ENV["LONO_TEST"] = "1"
ENV["LONO_ENV"] = "test"

require "lono"
require "rspec/lono"

module Helper
  # Your code goes here
end

RSpec.configure do |c|
  c.include RSpec::Lono::Helpers
  c.include Helper
end
