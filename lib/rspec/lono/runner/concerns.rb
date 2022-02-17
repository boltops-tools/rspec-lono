class RSpec::Lono::Runner
  module Concerns
    extend Memoist
    include Lono::AwsServices

    # Example:
    #     {
    #       "SecurityGroupId"=>"sg-08ca356e0a6d607e4",
    #       "SecurityGroup"=>"demo-test-SecurityGroup-17X56VTN9PRXH"
    #     }
    def outputs
      stack.outputs.inject({}) do |acc,o|
        acc.merge(o.output_key => o.output_value)
      end
    end

    def resources
      resp = describe_stack_resources(stack_name: @stack)
      resp.stack_resources
    end

    def stack
      find_stack(@stack)
    end
    memoize :stack

    def describe_stack_resources(options={})
      cfn.describe_stack_resources(options)
    end
    memoize :describe_stack_resources
  end
end
