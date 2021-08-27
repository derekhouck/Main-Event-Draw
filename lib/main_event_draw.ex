defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Acquires gimmicks using `confidence`
  """
  def acquire_gimmicks(current_state) do
    case Enum.find_index(current_state.gimmicks_available, fn gimmick -> gimmick.confidence_needed < current_state.confidence end) do
      nil -> current_state
      n when n >= 0 ->
        {[ selected_gimmick ], gimmicks_available } = draw_card(current_state.gimmicks_available)
        %{ current_state | gimmicks_available: gimmicks_available, discard: [ selected_gimmick | current_state.discard ], confidence: current_state.confidence - selected_gimmick.confidence_needed }
    end
  end

  @doc """
    Adds a card to the player's hand.

  ## Examples

      iex> MainEventDraw.add_card_to_hand("Example card", [])
      ["Example card"]

  """
  def add_card_to_hand(card, hand) do
    [ card | hand ]
  end

  @doc """
    Checks the current excitement level against the excitement level needed to win the match.
  """
  def check_excitement(current_state) do
    case current_state.excitement >= current_state.excitement_needed do
      true -> 
        IO.puts("The match is over! Congratulations!")
        %{ current_state | deck: [], hand: [], discard: Enum.concat([current_state.deck, current_state.hand, current_state.discard])}
      false -> current_state
    end
  end

  @doc """
    Creates a card based off of the type provided.
  
  ## Examples

      iex> MainEventDraw.create_card(:starter)
      %{ type: :starter, description: "Add 1 to confidence", confidence: 1, excitement: 0, confidence_needed: 0 }

  """
  def create_card(type) do
    case type do
      :gimmick -> %{ type: :gimmick, description: "Add 1 to excitement", confidence: 0, excitement: 1, confidence_needed: 3 }
      :starter -> %{ type: :starter, description: "Add 1 to confidence", confidence: 1, excitement: 0, confidence_needed: 0 }
    end
  end

  @doc """
    Creates the starting deck of cards for the player.

  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> Enum.count(deck)
      10

  """
  def create_starter_deck do
    Enum.map(0..9, fn _x -> create_card(:starter) end)
  end

  @doc """
    Creates the gimmick deck of cards that can be acquired using `confidence`.
  
  ## Examples

      iex> deck = MainEventDraw.create_gimmick_deck
      iex> Enum.count(deck)
      10

  """
  def create_gimmick_deck do
    Enum.map(0..9, fn _x -> create_card(:gimmick) end)
  end

  @doc """
    Draws a card from the deck. Returns a tuple containing two lists: the card drawn and the remainder of the deck.
  
  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> { [ card ], _remaining_deck } = MainEventDraw.draw_card(deck)
      iex> card
      %{
        description: "Add 1 to confidence",
        confidence: 1,
        excitement: 0,
        type: :starter,
        confidence_needed: 0
      }

  """
  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  @doc """
    Deals a hand of cards to the player from the deck.

  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> { hand, _remaining_deck } = MainEventDraw.deal_hand(deck)
      iex> Enum.count(hand)
      5

  """
  def deal_hand(deck, cards_left_to_draw \\ 5, hand \\ [])

  def deal_hand(deck, cards_left_to_draw, hand) when cards_left_to_draw == 0 do
    { deck, hand }
  end

  def deal_hand(deck, cards_left_to_draw, hand) do
    { [ card ], deck } = draw_card(deck)
    hand = add_card_to_hand(card, hand)

    deal_hand(deck, cards_left_to_draw - 1, hand) 
  end

  @doc """
    Joins a list of cards together into a comma-separated string.

  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> MainEventDraw.join_card_descriptions(deck)
      "Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence, Add 1 to confidence"

  """
  def join_card_descriptions(cards) do
    Enum.map(cards, fn card -> card.description end)
    |> Enum.join(", ")
  end

  @doc """
    Plays a card, removing it from the player's hand and increasing `confidence` by 1. Will run recursively until there are no more cards in the player's hand.
  """
  def play_card(state) when length(state.hand) == 0 do
    state
  end

  def play_card(state) do
    { [ card ], hand } = draw_card(state.hand)
    IO.puts("Playing #{card.description}")

    %{ state | confidence: state.confidence + card.confidence, excitement: state.excitement + card.excitement, hand: hand, discard: [ card | state.discard ] }
    |> check_excitement
    |> play_card
  end

  @doc """
    Puts the current state of the game in the console.
  """
  def report_current_state(state) do
    IO.puts("---")
    IO.puts("Hand: #{join_card_descriptions(state.hand)}")
    IO.puts("Deck: #{Enum.count(state.deck)} cards") 
    IO.puts("Discard: #{Enum.count(state.discard)} cards")
    IO.puts("Excitement: #{state.excitement}")
    IO.puts("Confidence: #{state.confidence}")
    IO.puts("Gimmicks available: #{join_card_descriptions(state.gimmicks_available)}")
    IO.puts("Gimmicks deck: #{Enum.count(state.gimmicks)}")
    IO.puts("---")
    state
  end

  @doc """
    Reveals a number of gimmicks so they can be acquired.
  """
  def reveal_gimmicks(state) do
    { gimmicks, gimmicks_available } = deal_hand(state.gimmicks, 6)
    %{ state | gimmicks: gimmicks, gimmicks_available: gimmicks_available }
  end

  @doc """
    Starts a game of Main Event Draw from its inital state.
  """
  def start_game do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")

    %{
      confidence: 0,
      deck: create_starter_deck(),
      discard: [],
      excitement: 0,
      excitement_needed: 10,
      gimmicks: create_gimmick_deck(),
      gimmicks_available: [],
      hand: []
    }
    |> reveal_gimmicks
    |> start_match
  end

  @doc """
    Starts a new match.
  """
  def start_match(state) do
    IO.puts("Our first match is Katana Jazz vs Ruby Dynamite")

    start_turn(state)
  end

  @doc """
    Starts a new turn. A new hand is dealt and the cards in the hand are played.
  """
  def start_turn(state) when length(state.deck) == 0 do
    IO.puts("No more cards left to draw.")
    report_current_state(state)
  end

  def start_turn(state) do
    { deck, hand } = deal_hand(state.deck)
    %{ state | confidence: 0, deck: deck, hand: hand }
    |> report_current_state
    |> play_card
    |> acquire_gimmicks
    |> start_turn
  end
end
