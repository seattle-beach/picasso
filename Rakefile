require 'rake/clean'

task :default => :build

desc 'Push to CF'
task :push => :build do
  sh 'cf push'
end

desc 'Run the dev server'
task :server => :build do
  sh 'rerun ruby picasso.rb'
end

task :build => 'public/picasso.js'

file 'public/picasso.js' => 'Picasso.elm' do |t|
  input = t.prerequisites[0]
  output = t.name
  sh "elm-make #{input} --output=#{output}"
end
CLOBBER.include('public/picasso.js')