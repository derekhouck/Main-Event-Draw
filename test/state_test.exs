defmodule StateTest do
  use ExUnit.Case
  doctest State

  test "autorun? will convert non-boolean values to true" do
    state = %State{ autorun: "of course" }
    
    assert State.autorun?(state) == true
  end
end