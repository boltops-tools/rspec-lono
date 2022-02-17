# rspec-lono

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Terraspec rspec helper methods. The usual testing process is:

1. Build a test harness. The test harness is a generated lono project with the specified blueprint.
2. Runs a `lono up` to create real resources.
3. Check the resources. In many cases, check the CloudFormation resources and outputs.
4. Runs a `lono down` to clean up the real resources.

## Test harness location

Where is the generated test harness located?

The test hardness is materialized into `/tmp/lono/test-harnesses/NAME`.

## Blueprint-Level and Project-Level Tests

The test helpers support both blueprint-level and project-level tests. See:

* [Lono Testing](https://lono.cloud/docs/testing/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-lono'
```

And then execute:

    $ bundle install
