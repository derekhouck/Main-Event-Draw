defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Acquires gimmicks using `confidence`
  """
  def acquire_gimmicks(current_state) do
    {[ gimmick ], gimmicks_available } = draw_card(current_state.gimmicks_available)
    %{ current_state | gimmicks_available: gimmicks_available, discard: [ gimmick | current_state.discard ], confidence: current_state.confidence - gimmick.confidence_needed }
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
    Creates the starting deck of cards for the player.

  ## Examples

      iex> MainEventDraw.create_starter_deck
      [
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"}, 
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"}
      ]

  """
  def create_starter_deck do
    Enum.map(0..9, fn _x -> %{ description: "Add 1 to confidence" } end)
  end

  @doc """
    Creates a gimmick card with a confidence cost and a description.

  ## Examples

      iex(80)> MainEventDraw.create_gimmick_card
      %{confidence_needed: 3, description: "Add 1 to excitement"}

  """
  def create_gimmick_card do
    %{
      confidence_needed: 3,
      description: "Add 1 to excitement"
    }
  end

  @doc """
    Creates the gimmick deck of cards that can be acquired using `confidence`.
  
  ## Examples

      iex> MainEventDraw.create_gimmick_deck
      [
        %{confidence_needed: 3, description: "Add 1 to excitement"}, 
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"},
        %{confidence_needed: 3, description: "Add 1 to excitement"}
      ]

  """
  def create_gimmick_deck do
    Enum.map(0..9, fn _x -> create_gimmick_card() end)
  end

  @doc """
    Draws a card from the deck. Returns a tuple containing two lists: the card drawn and the remainder of the deck.
  
  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> MainEventDraw.draw_card(deck)
      {[%{description: "Add 1 to confidence"}],
      [
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"}
      ]}

  """
  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  @doc """
    Deals a hand of cards to the player from the deck.

  ## Examples

      iex> deck = MainEventDraw.create_starter_deck
      iex> MainEventDraw.deal_hand(deck)
      {[
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"}
      ],
      [
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"},
        %{description: "Add 1 to confidence"}
      ]}

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

    %{ state | confidence: state.confidence + 1, hand: hand, discard: [ card | state.discard ] }
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
