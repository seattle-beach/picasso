require_relative 'picasso/web'

module Picasso
  class Draft
    attr_reader *%i[ state players ]

    def initialize
      @state, @players = :ready, []
    end
  end

  class Player
    attr_reader *%i[ state draft ]

    def join(draft)
      draft.players << self
      @draft = draft
      @state = :not_ready
    end
  end
end
