module RSpec::Lono
  module Helpers
    extend Memoist

    def harness
      Harness.new
    end
    memoize :harness

    def lono
      # Normally @blueprint is nil and Runner will infer blueprint. User can override with @blueprint.
      Runner.new(blueprint: @blueprint)
    end
    memoize :lono
  end
end
