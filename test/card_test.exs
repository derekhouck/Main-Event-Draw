defmodule CardTest do
  use ExUnit.Case
  doctest Card

  test "create_card creates gimmick cards" do
    card = Card.new(:gimmick)
    assert card.type == :gimmick
    assert card.description == "Add 1 to excitement"
    assert card.confidence == 0
    assert card.excitement == 1
    assert card.confidence_needed == 3
  end

  test "join_card_titles requires a map with a title key" do
    cards = ["Card One", "Card Two"]
    assert_raise ArgumentError, fn ->
      Card.join_card_titles(cards)
    end
  end
end