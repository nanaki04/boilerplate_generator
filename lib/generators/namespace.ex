defmodule BoilerplateGenerator.Namespace do
  alias CodeParserState.Namespace, as: Namespace

  @type state :: BoilerplateGenerator.state
  @type namespace :: CodeParserState.Namespace.namespace

  @spec generate_from_namespace(state, namespace) :: state
  def generate_from_namespace(state, namespace) do
    Namespace.classes(namespace)
    |> Enum.map(fn class ->
      Task.async(fn -> BoilerplateGenerator.Class.generate(state, namespace, class) end)
    end)
    |> (&Enum.map(Namespace.enums(namespace), fn enum ->
      Task.async(fn -> BoilerplateGenerator.Enum.generate(state, namespace, enum) end)
    end) ++ &1).()
    |> (&Enum.map(Namespace.interfaces(namespace), fn enum ->
      Task.async(fn -> BoilerplateGenerator.Interface.generate(state, namespace, enum) end)
    end) ++ &1).()
    |> Enum.map(&Task.await/1)
    |> Enum.filter(&is_binary/1)
    |> Enum.join("\n")
    |> (&%{state | result: state.result <> "\n" <> &1}).()
  end
end
