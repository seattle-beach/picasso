require 'rake/clean'

task :default => 'public/picasso.js'

task :push => 'public/picasso.js' do
  sh 'cf push'
end

task :server => 'public/picasso.js' do
  sh 'rerun ruby picasso.rb'
end

file 'public/picasso.js' => 'Picasso.elm' do |t|
  input = t.prerequisites[0]
  output = t.name
  sh "elm-make #{input} --output=#{output}"
end
CLOBBER.include('public/picasso.js')