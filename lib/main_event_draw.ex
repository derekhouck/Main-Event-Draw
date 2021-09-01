defmodule MainEventDraw do
  @moduledoc """
    Provides methods for creating and running a game of Main Event Draw
  """

  @doc """
    Acquires gimmicks using `confidence`
  """
  def acquire_gimmicks(%State{ 
      autorun: autorun, 
      confidence: confidence,
      gimmick_deck: gimmick_deck, 
      player_deck: player_deck 
      } = current_state) do

    case Enum.find_index(gimmick_deck.hand, fn gimmick -> gimmick.confidence_needed <= confidence end) do
      nil -> 
        IO.puts("End of turn")
        current_state
      n when n >= 0 ->
        { selected_gimmick, updated_gimmick_deck } = 
          case autorun do
            true -> Deck.acquire_gimmick(gimmick_deck)
            false -> 
              IO.puts("Confidence: #{confidence}")
              IO.puts("You have enough confidence to acquire a gimmick.")
              Deck.select_gimmick(gimmick_deck)
          end

        %State{ current_state | 
          confidence: confidence - selected_gimmick.confidence_needed,
          gimmick_deck: updated_gimmick_deck,
          player_deck: %Deck{ player_deck | discard: [ selected_gimmick | player_deck.discard ]} 
        }
        |> acquire_gimmicks
    end
  end

  @doc """
    Plays the cards in a player's hand one-by-one, removing them from the player's hand and updating state with their effects.
  """
  def play_cards(state) when length(state.player_deck.hand) == 0 do
    state   
  end

  def play_cards(%State{ player_deck: player_deck } = state) do
    state
    |> State.excitement_level_reached?
    |> case do
      true -> state
      false ->
        { [ card ], hand } = Card.draw(player_deck.hand)

        IO.puts("Playing #{card.title} (#{card.description})")

        updated_player_deck = %{ player_deck | discard: [ card | player_deck.discard ], hand: hand }

        new_state = %State{ state | player_deck: updated_player_deck }
        |> Card.Effect.apply(card.effect)

        IO.puts("Confidence: #{new_state.confidence}, Excitement: #{new_state.excitement}")

        new_state
        |> play_cards
    end
  end

  @doc """
    Reveals a number of gimmicks so they can be acquired.
  """
  def reveal_gimmicks(current_state) do
    %{ gimmick_deck: gimmick_deck } = current_state
    updated_gimmick_deck = Deck.deal_hand(gimmick_deck, 6)

    %{ current_state | gimmick_deck: updated_gimmick_deck }
  end

  @doc """
    Reveals a shoot event that affects the game state.
  """
  def reveal_shoot_events(%State{ event_deck: event_deck } = current_state) do
    { [ event ], remaining_draw } = Card.draw(event_deck.draw)
    IO.puts("New event: #{event.title}")
    updated_event_deck = %{ event_deck | draw: remaining_draw, discard: [ event_deck.discard | event ]}

    new_state = %State{ current_state | event_deck: updated_event_deck }
    |> Card.Effect.apply(event.effect)

    IO.puts("Drawing Power: #{new_state.draw_power}")

    new_state
  end

  @doc """
    Starts a game of Main Event Draw from its inital state.
  """
  def start_game(autorun \\ false) do
    IO.puts("Welcome to MAIN EVENT DRAAAAAAW!")

    %State{
      autorun: autorun,
      event_deck: %Deck{
        draw: Card.new_set(:event)
      },
      gimmick_deck: %Deck{
        draw: Card.new_set(:gimmick)
      },
      player_deck: %Deck{
        draw: Card.new_set(:starter)
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
    updated_player_deck = Deck.deal_hand(player_deck)
    IO.puts("New hand: #{Card.join_card_titles(updated_player_deck.hand)}")

    after_events_state = %{ current_state | confidence: 0, player_deck: updated_player_deck }
    |> reveal_shoot_events

    case State.draw_power_depleted?(after_events_state.draw_power) do
      true -> IO.puts("Oh no! The crowd is bored and they are leaving! You lose.")
      false ->
        new_state = play_cards(after_events_state)

        case State.excitement_level_reached?(new_state) do
          true -> IO.puts("The match is over! Congratulations!")
          false -> 
            new_state
            |> acquire_gimmicks
            |> start_turn
        end
    end
  end
end
