defmodule MainEventDraw do
  def create_starter_deck do
    Enum.map(0..9, fn _x -> "Add 1 to confidence" end)
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
    { deck, hand }
  end

  def deal_hand(deck, hand, cards_left_to_draw) do
    { deck, hand } = draw_card_and_add_to_hand(deck, hand)
    deal_hand(deck, hand, cards_left_to_draw - 1) 
  end

  def join_cards(cards) do
    Enum.join(cards, ", ")
  end

  def play_card(state) do
    { card, hand } = Enum.split(state.hand, 1)
    %{ state | confidence: state.confidence + 1, hand: hand, discard: [ card | state.discard ] }
  end

  def report_current_state(state) do
    IO.puts("Hand: #{join_cards(state.hand)}")
    IO.puts("Deck: #{Enum.count(state.deck)} cards") 
    IO.puts("Discard: #{Enum.count(state.discard)} cards")
    IO.puts("Confidence: #{state.confidence}")
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
    { deck, hand } = deal_hand(deck)
    state = %{
      deck: deck,
      discard: [],
      hand: hand,
      confidence: 0
    }
    report_current_state(state)
    state = play_card(state)
    report_current_state(state)
  end
end
