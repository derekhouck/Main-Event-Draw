defmodule StateTest do
  use ExUnit.Case
  doctest State

  test "autorun? will convert non-boolean values to true" do
    state = %State{ autorun: "of course" }
    
    assert State.autorun?(state) == true
  end

  test "excitement_level_reached returns false is excitment is lower than excitement_needed" do
    state = %State{ excitement: 9, excitement_needed: 10 }

    assert State.excitement_level_reached?(state) == false
  end
end