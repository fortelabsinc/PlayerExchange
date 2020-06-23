defmodule GuildTest do
  use ExUnit.Case
  doctest Guild

  test "greets the world" do
    assert Guild.hello() == :world
  end
end
