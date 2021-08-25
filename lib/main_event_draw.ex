defmodule MainEventDraw do
  def create_starter_deck do
    Enum.map(0..4, fn x -> "Add 1 influence" end)
  end

  def draw_hand(deck) do
    IO.puts("Hand: #{Enum.join(deck, ", ")}")
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
