require_relative 'test_helper'

require 'picasso'

class TestDraft < Test
  def setup
    total_cards = 8*NUM_PACKS*PACK_SIZE
    packs = (0...total_cards).to_a.shuffle.map(&:to_s).each_slice(PACK_SIZE).to_a
    @draft = Draft.new(packs: packs)
    @alice = Player.new
    @bob = Player.new
  end

  def test_new
    draft = Draft.new(packs: [])
    assert_empty draft.players
    assert_equal 0, draft.pack
  end

  def test_joining
    @alice.join(@draft)

    assert_equal 1, @draft.players.count
    assert_equal @draft, @alice.draft

    @bob.join(@draft)
    assert_equal 2, @draft.players.count
    assert_equal @draft, @bob.draft
  end

  def test_ready
    @alice.join(@draft)
    @alice.ready!
    assert_equal 3, @alice.packs.count
    alice_cards = @alice.packs.flat_map {|pack| pack}
    assert_equal 45, alice_cards.count

    @bob.join(@draft)
    @bob.ready!
    assert_equal 3, @bob.packs.count
    bob_cards = @bob.packs.flat_map {|pack| pack}
    assert_equal 45, bob_cards.count

    assert_empty alice_cards & bob_cards
  end

  def test_not_enough_packs
    8.times do
      player = Player.new
      player.join(@draft)
      player.ready!
    end

    assert_raises(NotEnoughPacks) do
      player = Player.new
      player.join(@draft)
      player.ready!
    end
  end
end
