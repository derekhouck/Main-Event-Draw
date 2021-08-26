defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Adds a card to the player's hand.
  """
  def add_card_to_hand(card, hand) do
    [ card | hand ]
  end

  @doc """
    Creates the starting deck of cards for the player.
  """
  def create_starter_deck do
    Enum.map(0..9, fn _x -> "Add 1 to confidence" end)
  end

  @doc """
    Creates the gimmick deck of cards that can be acquired using `confidence`.
  """
  def create_gimmick_deck do
    Enum.map(0..9, fn _x -> "Add 1 to excitement" end)
  end

  @doc """
    Draws a card from the deck. Returns a tuple containing two lists: the card drawn and the remainder of the deck.
  """
  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  @doc """
    Deals a hand of cards to the player from the deck.
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
  """
  def join_cards(cards) do
    Enum.join(cards, ", ")
  end

  @doc """
    Plays a card, removing it from the player's hand and increasing `confidence` by 1.
  """
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

  @doc """
    Puts the current state of the game in the console.
  """
  def report_current_state(state) do
    IO.puts("---")
    IO.puts("Hand: #{join_cards(state.hand)}")
    IO.puts("Deck: #{Enum.count(state.deck)} cards") 
    IO.puts("Discard: #{Enum.count(state.discard)} cards")
    IO.puts("Confidence: #{state.confidence}")
    IO.puts("Gimmicks available: #{join_cards(state.gimmicks_available)}")
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
  end

  def start_turn(state) do
    { deck, hand } = deal_hand(state.deck)
    %{ state | confidence: 0, deck: deck, hand: hand }
    |> report_current_state
    |> play_card
  end
end
