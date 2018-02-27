defmodule BoilerplateGeneratorTest do
  use ExUnit.Case
  doctest BoilerplateGenerator

  test "greets the world" do
    assert BoilerplateGenerator.hello() == :world
  end
end
