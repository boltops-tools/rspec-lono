module RSpec::Lono
  class Detector
    def blueprint
      md = calling_file.match(%r{/blueprints/(.*)/test/spec/})
      md[1]
    end

    def root
      calling_file.sub(%r{/test/spec/.*}, '') # IE: /home/user/lono-project/app/blueprints/demo
    end

    # Automatically discover the blueprint root path
    #
    # Caller lines are different for OSes:
    #
    #   windows: "C:/Users/user/lono-project/app/blueprints/demo/test/spec/blueprint_spec.rb:12:in `block (2 levels) in <top (required)>'"
    #   linux: "/home/user/lono-project/app/blueprints/demo/test/spec/blueprint_spec.rb:12:in `block (2 levels) in <top (required)>'"
    #
    def calling_file
      caller_line = caller.find { |l| l.include?("_spec.rb") }
      parts = caller_line.split(':')
      caller_line.match(/^[a-zA-Z]:/) ? parts[1] : parts[0]
    end
  end
end
