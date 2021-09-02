defmodule Deck do
  defstruct draw: [], discard: [], hand: []

  @doc """
    Acquires a gimmick from the hand/pool and refills the pool. Returns a tuple of the selected gimmick and the updated gimmick deck.
  
  ## Examples

      iex> deck = %Deck{ draw: Card.new_set(:gimmick) }
      iex> |> Deck.deal_hand(6)
      iex> {gimmick, remaining_deck} = Deck.acquire_gimmick(deck)
      iex> Enum.count(remaining_deck.draw) == Enum.count(deck.draw) - 1
      true
      iex> gimmick.type
      :gimmick

  """
  def acquire_gimmick(%Deck{ hand: hand } = deck, card_index \\ 0) do
    {selected_gimmick, remaining_hand } = Card.select(hand, card_index)

    updated_deck = %Deck{ deck | hand: remaining_hand }
    |> Deck.deal_hand(1)

    IO.puts("Acquiring #{selected_gimmick.title}")    

    { selected_gimmick, updated_deck }
  end

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

  @doc """
    Displays the available gimmicks to the player and asks them to select one.
  """
  def select_gimmick(deck) do
    Card.display_gimmick_options(deck.hand)
    IO.gets("Number of gimmick you want: ")
    |> String.trim
    |> Integer.parse
    |> case do
      {n, _r} when n in 1..6 -> Deck.acquire_gimmick(deck, n - 1)
      _ ->
        IO.puts("That doesn't look right. Only enter the number of the card you want to select.")
        Deck.select_gimmick(deck)
    end
  end
end