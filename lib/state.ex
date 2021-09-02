defmodule State do
  defstruct [
    :event_deck,
    :gimmick_deck,
    :player_deck,
    autorun: false,
    confidence: 0,
    draw_power: 10,
    excitement: 0,
    excitement_needed: 10,
  ]

  @doc """
    Tests whether autorun is set to a truthy value.
  
  ## Example
  
      iex> state = %State{ autorun: true }
      iex> State.autorun?(state)
      true

  """
  def autorun?(%State{ autorun: autorun }) do
    !!autorun
  end

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

  @doc """
    Returns true if `excitement` is greater than or equal to `excitement_needed`.
  
  ## Examples

      iex> state = %State{ excitement: 11, excitement_needed: 10 }
      iex> State.excitement_level_reached?(state)
      true

  """
  def excitement_level_reached?(%State{ excitement: excitement, excitement_needed: excitement_needed }) do
    excitement >= excitement_needed
  end
end