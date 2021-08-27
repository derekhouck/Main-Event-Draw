defmodule MainEventDrawTest do
  use ExUnit.Case
  doctest MainEventDraw

  test "acquire_gimmicks acquires a gimmick if it has enough confidence" do
    initial_state = %{ gimmicks_available: MainEventDraw.create_gimmick_deck, confidence: 5, discard: [] }
    new_state = MainEventDraw.acquire_gimmicks(initial_state)
    assert length(new_state.gimmicks_available) == length(initial_state.gimmicks_available) - 1
    assert new_state.confidence == initial_state.confidence - 3
    assert length(new_state.discard) == 1
  end

  test "acquire_gimmicks does not alter state if the player does not have enough confidence" do
    initial_state = %{ gimmicks_available: MainEventDraw.create_gimmick_deck, confidence: 2, discard: [] }
    new_state = MainEventDraw.acquire_gimmicks(initial_state)
    assert length(new_state.gimmicks_available) == length(initial_state.gimmicks_available)
    assert new_state.confidence == initial_state.confidence
    assert length(new_state.discard) == 0
  end

  test "create_card creates gimmick cards" do
    card = MainEventDraw.create_card(:gimmick)
    assert card.type == :gimmick
    assert card.description == "Add 1 to excitement"
    assert card.confidence == 0
    assert card.excitement == 1
    assert card.confidence_needed == 3
  end

  test "deal_hand deals the correct number of cards" do
    deck = MainEventDraw.create_starter_deck
    { _deck, hand } = MainEventDraw.deal_hand(deck, 4)
    assert length(hand) == 4
  end

  test "join_card_descriptions requires a map with a description key" do
    cards = ["Card One", "Card Two"]
    assert_raise ArgumentError, fn ->
      MainEventDraw.join_card_descriptions(cards)
    end
  end

  test "play_card empties the player's hand and adds those cards to the discard pile" do
    initial_state = %{hand: MainEventDraw.create_starter_deck, confidence: 0, discard: [], excitement: 0, excitement_needed: 10}
    new_state = MainEventDraw.play_card(initial_state)
    assert length(new_state.hand) == 0
    assert length(new_state.discard) == length(initial_state.hand)
  end

  test "reveal_gimmicks reveals 6 gimmick cards from the gimmick deck" do
    initial_state = %{ gimmicks: MainEventDraw.create_gimmick_deck, gimmicks_available: [] }
    new_state = MainEventDraw.reveal_gimmicks(initial_state)
    assert length(new_state.gimmicks) == length(initial_state.gimmicks) - 6
    assert length(new_state.gimmicks_available) == 6
  end
end
