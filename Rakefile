require 'rake/clean'
require 'rake/testtask'

task :default => :build

desc 'Push to CF'
task :push => :build do
  sh 'cf push'
end

desc 'Run the server'
task :server => :build do
  sh "puma --bind tcp://0.0.0.0:#{ENV['PORT']} config.ru"
end

desc 'Run a dev server (that automatically refreshes)'
task :dev do
  sh 'rerun --pattern "**/*.{rb,elm}" rake server'
end

task :build => 'public/picasso.js'

file 'public/picasso.js' => 'src/Picasso.elm' do |t|
  input = t.prerequisites[0]
  output = t.name
  sh "elm-make #{input} --output=#{output}"
end
CLOBBER.include('public/picasso.js')

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

# This is here so rerun can properly kill
# Puma before restarting the dev server.
Signal.trap('TERM') do
  sh 'pkill -INT -f puma'
end
