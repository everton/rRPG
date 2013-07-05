require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => [:test]

task :new_kids_on_the_block do
  require 'tempfile'
  require 'ruby-debug'

  wrapped_source = Tempfile.new('wrapped_source')
  wrapped_source.puts 'debugger'
  wrapped_source.write File.read('run')
  wrapped_source.close

  compiled_source = RubyVM::InstructionSequence
    .compile_file wrapped_source.path
  compiled_source.eval
end

task :clean do
  `rm -rf coverage/*`
  `find ./ -name \\*~ -delete`
end

task :test => [:clean]

task :stats => :clean do
  tloc  = `find ./test/ -name \\*.rb -exec cat {} \\; |sed /^\w*$/d |wc -l`.to_i
  lloc  = `find ./lib   -name \\*.rb -exec cat {} \\; |sed /^\w*$/d |wc -l`.to_i
  ratio = tloc.to_f / lloc

  puts "Code LOC: #{lloc}\tTest LOC: #{tloc}\tCode to Test Ratio: 1:%.2f" % ratio
end
