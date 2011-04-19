require 'rake/testtask'
require 'simplecov'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => [:test]

task :clean do
  `rm -rf coverage/*`
  `find ./ -name \\*~ -delete`
end

task :test => [:clean]
