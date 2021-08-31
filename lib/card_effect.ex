defmodule Card.Effect do
  @doc """
    Applies the named effect to the current game state by the amount specified.

  ## Examples

    iex> state = %State{ draw_power: 10 }
    iex> effect = { :reduce_draw_power, 2 }
    iex> new_state = Card.Effect.apply(state, effect)
    iex> new_state.draw_power
    8

  """
  def apply(current_state, { method_name, amount }) do
    apply(Card.Effect, method_name, [ current_state, amount ])
  end

  @doc """
    Increases confidence by the amount specified.

  ## Examples

      iex> state = %State{ confidence: 1 }
      iex> new_state = Card.Effect.add_confidence(state, 5)
      iex> new_state.confidence
      6
  """
  def add_confidence(current_state, amount) do
    %State{ current_state | confidence: current_state.confidence + amount }
  end

  @doc """
    Increases excitement by the amount specified.

  ## Examples

      iex> state = %State{ excitement: 1 }
      iex> new_state = Card.Effect.add_excitement(state, 5)
      iex> new_state.excitement
      6
  """
  def add_excitement(current_state, amount) do
    %State{ current_state | excitement: current_state.excitement + amount }
  end

  @doc """
    Reduces draw_power by the amount specified.

  ## Examples

      iex> state = %State{ draw_power: 10 }
      iex> new_state = Card.Effect.reduce_draw_power(state, 2)
      iex> new_state.draw_power
      8
      
  """
  def reduce_draw_power(current_state, amount) do
    %State{ current_state | draw_power: current_state.draw_power - amount }
  end
end