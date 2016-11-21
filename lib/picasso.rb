require_relative 'picasso/web'

module Picasso
  class Draft
    attr_reader *%i[ state players ]

    def initialize
      @state, @players = :ready, []
    end
  end

  class Player
    attr_reader :draft

    def join(draft)
      draft.players << self
      @draft = draft
    end
  end
end
