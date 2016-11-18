require 'rake/clean'

task :default => 'picasso.js'

file 'picasso.js' => 'Picasso.elm' do |t|
  input = t.prerequisites[0]
  output = t.name
  sh "elm-make #{input} --output=#{output}"
end
CLOBBER.include('picasso.js')