# @author Tom Cox <https://github.com/koxzi95>
# # Required if CI fails default task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec


# require 'rspec/core/rake_task'
# task :default => :spec
# RSpec::Core::RakeTask.new
