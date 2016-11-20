$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'picasso/web'
run Picasso::Web
