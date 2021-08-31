defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Acquires gimmicks using `confidence`
  """
  def acquire_gimmicks(
    %{ gimmick_deck: gimmick_deck, player_deck: player_deck } = current_state
    ) do
    IO.puts("Available gimmicks: #{Card.join_card_titles(gimmick_deck.hand)}")

    case Enum.find_index(gimmick_deck.hand, fn gimmick -> gimmick.confidence_needed < current_state.confidence end) do
      nil -> current_state
      n when n >= 0 ->
        {[ selected_gimmick ], hand } = draw_card(gimmick_deck.hand)
        updated_gimmick_deck = %{ gimmick_deck | hand: hand }
        |> deal_hand(1)

        IO.puts("Acquiring #{selected_gimmick.title}")
        IO.puts("End of turn")

        %{ current_state | 
          confidence: current_state.confidence - selected_gimmick.confidence_needed,
          gimmick_deck: updated_gimmick_deck,
          player_deck: %{ player_deck | discard: [ selected_gimmick | player_deck.discard ]} 
        }
    end
  end

  @doc """
    Draws a card from the deck. Returns a tuple containing two lists: the card drawn and the remainder of the deck.
  
  ## Examples

      iex> deck = Card.create_cards(:starter)
      iex> { [ card ], _remaining_deck } = MainEventDraw.draw_card(deck)
      iex> card
      %Card{
        description: "Add 1 to confidence",
        confidence: 1,
        excitement: 0,
        type: :starter,
        confidence_needed: 0,
        effect: "+1 Confidence",
        title: "Basic Spot"
      }

  """
  def draw_card(deck) do
    Enum.split(deck, 1)
  end

  @doc """
    Deals a hand of cards to the player from the deck.

  ## Examples

      iex> deck = %{ draw: Card.create_cards(:starter), hand: [] }
      iex> updated_deck = MainEventDraw.deal_hand(deck)
      iex> Enum.count(updated_deck.hand)
      5

  """
  def deal_hand(deck, cards_left_to_draw \\ 5) 

  def deal_hand(deck, 0) do
    deck
  end

  def deal_hand(
    %{ discard: discard } = deck, cards_left_to_draw
    ) when length(deck.draw) == 0 do
    case Enum.count(discard) do
      n when n > 0 ->
        %{ deck | draw: Card.shuffle_cards(discard), discard: [] }
        |> deal_hand(cards_left_to_draw)
      0 ->
        IO.puts("Deck is empty")
        deck
    end
  end
  
  def deal_hand(%{ draw: draw, hand: hand } = deck, cards_left_to_draw) do
    { [ card ], remaining_draw } = draw_card(draw)
    updated_deck = %{ deck | draw: remaining_draw, hand: [ card | hand ]}

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
    Plays the cards in a player's hand one-by-one, removing them from the player's hand and updating state with their effects.
  """
  def play_cards(state) when length(state.player_deck.hand) == 0 do
    state   
  end

  def play_cards(state) do
    %{ player_deck: player_deck } = state

    case excitement_level_reached?(state.excitement, state.excitement_needed) do
      true -> state
      false ->
        { [ card ], hand } = draw_card(player_deck.hand)
        IO.puts("Playing #{card.title} (#{card.effect})")
        updated_player_deck = %{ player_deck | discard: [ card | player_deck.discard ], hand: hand }
        updated_confidence = state.confidence + card.confidence
        updated_excitement = state.excitement + card.excitement
        IO.puts("Confidence: #{updated_confidence}, Excitement: #{updated_excitement}")
    
        %{ state | confidence: updated_confidence, excitement: updated_excitement, player_deck: updated_player_deck }
        |> play_cards
    end
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
    Reveals a shoot event that affects the game state.
  """
  def reveal_shoot_events(current_state) do
    IO.puts("This will reveal a shoot event each turn")
    current_state
  end

  @doc """
    Starts a game of Main Event Draw from its inital state.
  """
  def start_game do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")

    %State{
      event_deck: %MainEventDraw.Deck{
        draw: Card.create_cards(:event)
      },
      gimmick_deck: %MainEventDraw.Deck{
        draw: Card.create_cards(:gimmick)
      },
      player_deck: %MainEventDraw.Deck{
        draw: Card.create_cards(:starter)
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
  def start_turn(current_state) do
    %{ player_deck: player_deck } = current_state
    updated_player_deck = deal_hand(player_deck)
    IO.puts("New hand: #{Card.join_card_titles(updated_player_deck.hand)}")

    new_state = %{ current_state | confidence: 0, player_deck: updated_player_deck }
    |> reveal_shoot_events
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
