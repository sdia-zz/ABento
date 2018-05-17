defmodule AbentoTest do
  use ExUnit.Case
  doctest Abento

  test "greets the world" do
    assert Abento.hello() == :world
  end
end
