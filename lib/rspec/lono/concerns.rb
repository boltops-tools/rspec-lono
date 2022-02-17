module RSpec::Lono
  module Concerns
    extend Memoist
    include Logging

    def detection
      Detector.new
    end
    memoize :detection
  end
end
