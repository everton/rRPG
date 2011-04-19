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

task :stats => :clean do
  tloc  = `find ./test/ -name \\*.rb -exec cat {} \\; |wc -l`.to_i
  lloc  = `find ./lib   -name \\*.rb -exec cat {} \\; |wc -l`.to_i
  ratio = tloc.to_f / lloc

  puts "Code LOC: #{lloc}\tTest LOC: #{tloc}\tCode to Test Ratio: 1:%.2f" % ratio
end
