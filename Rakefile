require 'rake/clean'

task :default => 'public/picasso.js'

file 'public/picasso.js' => 'Picasso.elm' do |t|
  input = t.prerequisites[0]
  output = t.name
  sh "elm-make #{input} --output=#{output}"
end
CLOBBER.include('public/picasso.js')