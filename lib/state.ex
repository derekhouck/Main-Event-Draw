defmodule State do
  defstruct [
    :event_deck,
    :gimmick_deck,
    :player_deck,
    confidence: 0,
    draw_power: 10,
    excitement: 0,
    excitement_needed: 10,
  ]

  @doc """
    Returns true if draw_power is not greater than 0.

  ## Example

      iex> state = %State{ draw_power: 0 }
      iex> State.draw_power_depleted?(state.draw_power)
      true

  """
  def draw_power_depleted?(draw_power) do
    draw_power <= 0
  end
end