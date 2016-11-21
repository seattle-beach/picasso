require_relative 'test_helper'

require 'picasso'

class TestDraft < Test
  def setup
    @draft = Draft.new
    @alice = Player.new
    @bob = Player.new
  end

  def test_new
    draft = Draft.new
    assert_empty draft.players
    assert_equal :ready, draft.state
  end

  def test_joining
    @alice.join(@draft)

    assert_equal 1, @draft.players.count
    assert_equal @draft, @alice.draft
    assert_equal :not_ready, @alice.state

    @bob.join(@draft)
    assert_equal 2, @draft.players.count
    assert_equal @draft, @bob.draft
    assert_equal :not_ready, @alice.state
  end
end
