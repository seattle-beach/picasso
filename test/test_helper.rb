require 'minitest/autorun'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

module Picasso
  class Test < Minitest::Test
  end
end

include Picasso
