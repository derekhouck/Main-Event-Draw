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