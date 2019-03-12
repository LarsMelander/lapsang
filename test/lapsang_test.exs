defmodule LapsangTest do
  use ExUnit.Case
  doctest Lapsang

  test "greets the world" do
    assert Lapsang.hello() == :world
  end
end
