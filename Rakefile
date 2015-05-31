require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { search_gems: true,
                  tags: %w(~rackspace-support),
                  fail_tags: %w(correctness,rackspace)
                }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Integration tests - kitchen.ci
desc 'Run Test Kitchen'
namespace :integration do
  Kitchen.logger = Kitchen.default_file_logger

  desc 'Run kitchen test with Vagrant'
  task :vagrant do
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Default
task default: ['style', 'integration:vagrant']
