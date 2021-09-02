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

  def display_hand(%Deck{hand: hand}, cost_included \\ false) do
    cards = Enum.with_index(hand)

    Enum.each(cards, fn({card, i}) ->
      IO.puts("#{i + 1}. #{card.title}")
      IO.puts("   #{card.description}")
      if cost_included do
        IO.puts("   Confidence needed: #{card.confidence_needed}")
      end
    end)
  end

  @doc """
    Returns true is a deck's hand is empty.

  ## Examples

      iex> deck = %Deck{ hand: [] }
      iex> Deck.empty_hand?(deck)
      true

      iex> deck_with_hand = %Deck{ hand: Card.new_set(:starter) }
      iex> Deck.empty_hand?(deck_with_hand)
      false

  """
  def empty_hand?(deck) do
    length(deck.hand) == 0
  end

  def select_from_hand(%Deck{ hand: hand } = deck) do
    display_hand(deck)
    MainEventDraw.get_number_from_input("Number of card to play: ")
    |> case do
      n when n in 1..length(hand) ->
        Card.select(hand, n - 1)
      _ ->
        IO.puts("Only enter a number corresponding to a card in your hand.")
        select_from_hand(deck)
    end
  end
end