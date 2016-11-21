require_relative 'picasso/web'

module Picasso
  NUM_PACKS = 3
  PACK_SIZE = 15

  class NotEnoughPacks < StandardError; end

  class Draft
    attr_reader *%i[ packs pack players ]

    def initialize(packs:)
      @packs, @pack, @players = packs.shuffle, 0, []
    end
  end

  class Player
    attr_reader *%i[ draft packs cards ]

    def join(draft: draft)
      raise NotEnoughPacks if draft.packs.count < NUM_PACKS

      draft.players << self
      @draft = draft
      @packs = []
      NUM_PACKS.times do
        @packs << draft.packs.shift
      end
    end

    def ready!
    end
  end
end
