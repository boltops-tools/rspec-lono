require "json"

# Named Lo so dont have to fully qualify ::Lono within RSpec::Lono
module RSpec::Lono
  class Runner
    CLI = Lono::CLI
    include RSpec::Lono::Concerns
    include RSpec::Lono::Runner::Concerns
    extend Memoist

    def initialize(options={})
      @options = options
      @options[:blueprint] ||= detection.blueprint
      @options[:name] ||= @options[:blueprint]
      @blueprint = Lono::Blueprint.new(@options) # uses @options[:name]
      @stack = Lono::Names.new(@options).stack   # uses @options[:blueprint]
      @name = @blueprint.name
    end

    def build(args='')
      run("build #{@name} #{args}")
    end

    def up(args='')
      run("up #{@name} #{args} -y")
    end

    def down(args='')
      run("down #{@name} #{args} -y")
      self.flush_cache
    end

    def run(command)
      command = command.strip
      puts "=> LONO_ENV=#{Lono.env} lono #{command}".color(:green)
      args = command.split(' ')
      CLI.start(args)
    end
  end
end
