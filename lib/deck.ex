defmodule Deck do
  defstruct draw: [], discard: [], hand: []

  @doc """
    Deals a hand of cards to the player from the deck.

  ## Examples

      iex> deck = %Deck{ draw: Card.new_set(:starter), hand: [] }
      iex> updated_deck = Deck.deal_hand(deck)
      iex> Enum.count(updated_deck.hand)
      5

  """
  def deal_hand(deck, cards_left_to_draw \\ 5) 

  def deal_hand(deck, 0) do
    deck
  end

  def deal_hand(
    %Deck{ discard: discard } = deck, cards_left_to_draw
    ) when length(deck.draw) == 0 do
    case Enum.count(discard) do
      n when n > 0 ->
        %Deck{ deck | draw: Card.shuffle_cards(discard), discard: [] }
        |> deal_hand(cards_left_to_draw)
      0 ->
        IO.puts("Deck is empty")
        deck
    end
  end
  
  def deal_hand(%{ draw: draw, hand: hand } = deck, cards_left_to_draw) do
    { [ card ], remaining_draw } = Card.draw(draw)
    updated_deck = %Deck{ deck | draw: remaining_draw, hand: [ card | hand ]}

    deal_hand(updated_deck, cards_left_to_draw - 1) 
  end
end