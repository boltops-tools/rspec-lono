module RSpec::Lono::Concerns
  module Logging
    def logger
      RSpec::Lono.logger
    end
  end
end
