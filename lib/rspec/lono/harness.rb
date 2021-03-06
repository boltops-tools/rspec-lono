module RSpec::Lono
  class Harness
    def initialize(options={})
      @options = options
    end

    def build(options={})
      setup
      project = Project.new(@options.merge(options))
      root = project.create
      Lono.root = root # switch root to the generated test harness
    end

    def setup
      # Require gems in Gemfile so lono_plugin_* gets loaded and registered
      # This it test Gemfile. IE: app/stacks/demo/test/Gemfile
      Kernel.require "bundler/setup"
      Bundler.require # Same as Bundler.require(:default)
      Lono.check_project = false
    end
  end
end
