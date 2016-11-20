require_relative 'picasso/web'

module Picasso
  class Draft
    attr_reader *%i[ state players ]

    def initialize
      @state, @players = :ready, []
    end
  end
end
