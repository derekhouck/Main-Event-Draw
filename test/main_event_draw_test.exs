defmodule MainEventDrawTest do
  use ExUnit.Case
  doctest MainEventDraw

  test "acquire_gimmicks acquires a gimmick if it has enough confidence" do
    gimmick_deck = %{ hand: Card.new_set(:gimmick), draw: Card.new_set(:gimmick)}
    player_deck = %{ discard: [] }
    initial_state = %{ confidence: 5, player_deck: player_deck, gimmick_deck: gimmick_deck }
    new_state = MainEventDraw.acquire_gimmicks(initial_state)

    assert length(new_state.gimmick_deck.draw) == length(gimmick_deck.draw) - 1
    assert new_state.confidence == initial_state.confidence - 3
    assert length(new_state.player_deck.discard) == 1
  end

  test "acquire_gimmicks does not alter state if the player does not have enough confidence" do
    gimmick_deck = %{ hand: Card.new_set(:gimmick), draw: Card.new_set(:gimmick) }
    player_deck = %{ discard: [] }
    initial_state = %{ confidence: 2, player_deck: player_deck, gimmick_deck: gimmick_deck }
    new_state = MainEventDraw.acquire_gimmicks(initial_state)

    assert length(new_state.gimmick_deck.hand) == length(gimmick_deck.hand)
    assert new_state.confidence == initial_state.confidence
    assert length(new_state.player_deck.discard) == 0
  end

  test "deal_hand deals the correct number of cards" do
    deck = %{ draw: Card.new_set(:starter), hand: [] }
    updated_deck = MainEventDraw.deal_hand(deck, 4)
    assert length(updated_deck.hand) == 4
  end

  test "excitement_level_reached returns false is excitment is lower than excitement_needed" do
    assert MainEventDraw.excitement_level_reached?(9, 10) == false
  end

  test "play_cards empties the player's hand and adds those cards to the discard pile" do
    player_deck = %{ discard: [], hand: Card.new_set(:starter)}
    initial_state = %{ confidence: 0, excitement: 0, excitement_needed: 10, player_deck: player_deck }
    new_state = MainEventDraw.play_cards(initial_state)

    assert length(new_state.player_deck.hand) == 0
    assert length(new_state.player_deck.discard) == length(player_deck.hand)
  end

  test "reveal_gimmicks reveals 6 gimmick cards from the gimmick deck" do
    gimmick_deck = %{ draw: Card.new_set(:gimmick), hand: [] }
    initial_state = %{ gimmick_deck: gimmick_deck }
    new_state = MainEventDraw.reveal_gimmicks(initial_state)

    assert length(new_state.gimmick_deck.draw) == length(gimmick_deck.draw) - 6
    assert length(new_state.gimmick_deck.hand) == 6
  end
end
