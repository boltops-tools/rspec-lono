module RSpec::Lono
  module Core
    cattr_writer :logger
    def logger
      @@logger ||= Lono.logger
    end
  end
end
