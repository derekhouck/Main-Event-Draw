defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Acquires gimmicks using `confidence`
  """
  def acquire_gimmicks(current_state) do
    %{ gimmick_deck: gimmick_deck, player_deck: player_deck } = current_state

    case Enum.find_index(gimmick_deck.hand, fn gimmick -> gimmick.confidence_needed < current_state.confidence end) do
      nil -> current_state
      n when n >= 0 ->
        {[ selected_gimmick ], hand } = draw_card(gimmick_deck.hand)
        updated_gimmick_deck = %{ gimmick_deck | hand: hand }

        %{ current_state | 
          confidence: current_state.confidence - selected_gimmick.confidence_needed,
          gimmick_deck: updated_gimmick_deck,
          player_deck: %{ player_deck | discard: [ selected_gimmick | player_deck.discard ]} 
        }
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
    Checks the current excitement level against the excitement level needed to win the match. If reached, ends the playing of cards by emptying the hand.
  """
  def check_excitement(current_state) do
    case excitement_level_reached?(current_state.excitement, current_state.excitement_needed) do
      true -> 
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

      iex> deck = %{ draw: MainEventDraw.create_starter_deck, hand: [] }
      iex> updated_deck = MainEventDraw.deal_hand(deck)
      iex> Enum.count(updated_deck.hand)
      5

  """
  def deal_hand(deck, cards_left_to_draw \\ 5) 

  def deal_hand(deck, cards_left_to_draw) when cards_left_to_draw == 0 do
    deck
  end

  def deal_hand(deck, cards_left_to_draw) do
    { [ card ], remaining_draw } = draw_card(deck.draw)
    hand = add_card_to_hand(card, deck.hand)
    updated_deck = %{ deck | draw: remaining_draw, hand: hand }

    deal_hand(updated_deck, cards_left_to_draw - 1) 
  end

  @doc """
    Returns true if `excitement` is greater than or equal to `excitement_needed`.
  
  ## Examples

      iex> excitement = 11
      iex> excitement_needed = 10
      iex> MainEventDraw.excitement_level_reached?(excitement, excitement_needed)
      true

  """
  def excitement_level_reached?(excitement, excitement_needed) do
    excitement >= excitement_needed
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
    Plays the cards in a player's hand one-by-one, removing them from the player's hand and updating state with their effects.
  """
  def play_cards(state) when length(state.player_deck.hand) == 0 do
    state
  end

  def play_cards(state) do
    %{ player_deck: player_deck } = state
    { [ card ], hand } = draw_card(player_deck.hand)
    IO.puts("Playing #{card.description}")
    updated_player_deck = %{ player_deck | discard: [ card | player_deck.discard ], hand: hand }

    %{ state | confidence: state.confidence + card.confidence, excitement: state.excitement + card.excitement, player_deck: updated_player_deck }
    |> check_excitement
    |> play_cards
  end

  @doc """
    Puts the current state of the game in the console.
  """
  def report_current_state(state) do
    %{ gimmick_deck: gimmick_deck, player_deck: player_deck } = state

    IO.puts("---")
    IO.puts("Excitement: #{state.excitement}")
    IO.puts("Confidence: #{state.confidence}")
    IO.puts("Gimmicks deck:")
    IO.puts("- Available to aquire: #{join_card_descriptions(gimmick_deck.hand)}")
    IO.puts("- Draw pile: #{Enum.count(gimmick_deck.draw)} cards")
    IO.puts("Player deck:")
    IO.puts("- Hand: #{join_card_descriptions(player_deck.hand)}")
    IO.puts("- Draw pile: #{Enum.count(player_deck.draw)} cards")
    IO.puts("- Discard pile: #{Enum.count(player_deck.discard)} cards")
    IO.puts("---")
    state
  end

  @doc """
    Reveals a number of gimmicks so they can be acquired.
  """
  def reveal_gimmicks(current_state) do
    %{ gimmick_deck: gimmick_deck } = current_state
    updated_gimmick_deck = deal_hand(gimmick_deck, 6)

    %{ current_state | gimmick_deck: updated_gimmick_deck }
  end

  @doc """
    Starts a game of Main Event Draw from its inital state.
  """
  def start_game do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")

    %{
      confidence: 0,
      excitement: 0,
      excitement_needed: 10,
      gimmick_deck: %{
        draw: create_gimmick_deck(),
        hand: []
      },
      player_deck: %{
        draw: create_starter_deck(),
        discard: [],
        hand: []
      }
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
  def start_turn(state) when length(state.player_deck.draw) == 0 do
    IO.puts("No more cards left to draw.")
    report_current_state(state)
  end

  def start_turn(current_state) do
    %{ player_deck: player_deck } = current_state
    updated_player_deck = deal_hand(player_deck)

    new_state = %{ current_state | confidence: 0, player_deck: updated_player_deck }
    |> report_current_state
    |> play_cards

    case excitement_level_reached?(new_state.excitement, new_state.excitement_needed) do
      true -> IO.puts("The match is over! Congratulations!")
      false -> 
        new_state
        |> acquire_gimmicks
        |> start_turn
    end
  end
end
