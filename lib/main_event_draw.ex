defmodule MainEventDraw do
  def create_starter_deck do
    Enum.map(0..9, fn x -> "Add 1 influence" end)
  end

  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  def draw_card_and_add_to_hand(deck, hand) do
    { card, deck } = draw_card(deck)
    { deck, [ card | hand ] }
  end

  def deal_hand(deck) do
    { deck, hand } = draw_card_and_add_to_hand(deck, [])
    deal_hand(deck, hand, 4)
  end
  
  def deal_hand(deck, hand, cards_left_to_draw) when cards_left_to_draw == 0 do
    IO.puts("Hand: #{join_cards(hand)}")
    IO.puts("Deck: #{Enum.count(deck)} cards")
  end

  def deal_hand(deck, hand, cards_left_to_draw) do
    { deck, hand } = draw_card_and_add_to_hand(deck, hand)
    deal_hand(deck, hand, cards_left_to_draw - 1) 
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
    deal_hand(deck)
  end
end
