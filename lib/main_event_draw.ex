defmodule MainEventDraw do
  def create_starter_deck do
    Enum.map(0..9, fn x -> "Add 1 influence" end)
  end

  def draw_card(deck) do
    %{card: Enum.take(deck, 1), deck: Enum.drop(deck, 1)}
  end

  # TODO: Draw 5 cards
  def draw_hand(deck) do
    state = draw_card(deck)
    IO.puts("Hand: #{state.card}")
    IO.puts("Deck: #{join_cards(state.deck)}")
  end

  def join_cards(cards) do
    Enum.join(cards, ", ")
  end

  def start_game do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")
    deck = create_starter_deck()
    start_match(deck)
  end

  def start_match(deck) do
    IO.puts("Our first match is Katana Jazz vs Ruby Dynamite")
    start_turn(deck)
  end

  def start_turn(deck) do
    draw_hand(deck)
  end
end
