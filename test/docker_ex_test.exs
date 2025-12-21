defmodule DockerExTest do
  use ExUnit.Case
  doctest DockerEx

  test "greets the world" do
    assert DockerEx.hello() == :world
  end
end
