require_relative 'test_helper'

require 'picasso'

class TestDraft < Test
  def setup
    @draft = Draft.new
  end

  def test_new
    assert_empty @draft.players
    assert_equal :ready, @draft.state
  end
end
