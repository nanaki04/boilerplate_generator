defmodule BoilerplateGeneratorTest do
  use ExUnit.Case
  doctest BoilerplateGenerator

  test "can generate multiple files" do
    result = CodeParserState.Example.generate
    |> BoilerplateGenerator.generate(extension: ".cs")
    assert :ok = result
    assert {:ok, _} = File.read("Dummy/Namespace/Extreme/DummyClass.cs")
  end

  test "can generate a single file" do
    result = CodeParserState.Example.generate
    |> BoilerplateGenerator.generate(single_file: true, extension: ".uml")
    assert :ok = result
    assert {:ok, _} = File.read("export.uml")
  end
end
