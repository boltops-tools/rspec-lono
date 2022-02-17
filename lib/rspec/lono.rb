# frozen_string_literal: true

require_relative "lono/version"

require "active_support"
require "active_support/core_ext/class"
require "active_support/core_ext/hash"
require "active_support/core_ext/string"
require "memoist"
require "rainbow/ext/string"

require_relative "lono/autoloader"
RSpec::Lono::Autoloader.setup

module RSpec
  module Lono
    class Error < StandardError; end
    extend Core
  end
end

require "lono"

Lono::Plugin::Tester.register("rspec",
  root: File.expand_path("../..", __dir__)
)
