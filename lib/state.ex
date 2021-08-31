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
end