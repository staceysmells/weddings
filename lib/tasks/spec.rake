# @author Tom Cox <https://github.com/koxzi95>
## Required if CI fails default task

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec


# require 'rspec/core/rake_task'
# RSpec::Core::RakeTask.new(:spec)
# task :default => :spec

# begin
#   require 'rspec/core/rake_task'
#   desc "Run all examples"
#   RSpec::Core::RakeTask.new(:spec) do |t|
#     t.rspec_opts = %w[--color]
#     t.pattern = 'spec/*_spec.rb'
#   end
# rescue LoadError
# end
