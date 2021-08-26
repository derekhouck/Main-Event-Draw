defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  def create_starter_deck do
    Enum.map(0..9, fn _x -> "Add 1 to confidence" end)
  end

  def create_gimmick_deck do
    Enum.map(0..9, fn _x -> "Add 1 to excitement" end)
  end

  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  def draw_card_and_add_to_hand(deck, hand) do
    { [ card ], deck } = draw_card(deck)
    { deck, [ card | hand ] }
  end

  def deal_hand(deck, hand \\ [], cards_left_to_draw \\ 5)

  def deal_hand(deck, hand, cards_left_to_draw) when cards_left_to_draw == 0 do
    { deck, hand }
  end

  def deal_hand(deck, hand, cards_left_to_draw) do
    { deck, hand } = draw_card_and_add_to_hand(deck, hand)
    deal_hand(deck, hand, cards_left_to_draw - 1) 
  end

  def join_cards(cards) do
    Enum.join(cards, ", ")
  end

  def play_card(state) when length(state.hand) == 0 do
    start_turn(state)
  end

  def play_card(state) do
    { [ card ], hand } = Enum.split(state.hand, 1)
    IO.puts("Playing #{card}")

    %{ state | confidence: state.confidence + 1, hand: hand, discard: [ card | state.discard ] }
    |> report_current_state
    |> play_card
  end

  def report_current_state(state) do
    IO.puts("---")
    IO.puts("Hand: #{join_cards(state.hand)}")
    IO.puts("Deck: #{Enum.count(state.deck)} cards") 
    IO.puts("Discard: #{Enum.count(state.discard)} cards")
    IO.puts("Confidence: #{state.confidence}")
    IO.puts("Gimmicks available: #{Enum.count(state.gimmicks)}")
    IO.puts("---")
    state
  end

  def start_game do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")

    %{
      deck: create_starter_deck(),
      discard: [],
      gimmicks: create_gimmick_deck(),
      hand: [],
      confidence: 0
    }
    |> start_match
  end

  def start_match(state) do
    IO.puts("Our first match is Katana Jazz vs Ruby Dynamite")

    start_turn(state)
  end

  def start_turn(state) when length(state.deck) == 0 do
    IO.puts("No more cards left to draw.")
  end

  def start_turn(state) do
    { deck, hand } = deal_hand(state.deck)
    %{ state | confidence: 0, deck: deck, hand: hand }
    |> report_current_state
    |> play_card
  end
end
