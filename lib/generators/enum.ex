defmodule BoilerplateGenerator.Enum do
  alias CodeParserState.Namespace, as: Namespace
  alias CodeParserState.Enum, as: EnumState
  alias CodeParserState.Class, as: Class
  alias BoilerplateGenerator.EnumProperty, as: PropertyGenerator

  @type state :: BoilerplateGenerator.state
  @type namespace :: %Namespace{}
  @type enum :: %EnumState{}
  @type ok :: BoilerplateGenerator.Exporter.ok
  @type error :: BoilerplateGenerator.Exporter.error

  @spec generate(state, namespace, enum) :: ok | error
  def generate(state, namespace, enum) do
    state.enum_template
    |> String.replace(~r/<\{namespace\}>/, Namespace.name namespace)
    |> String.replace(~r/<\{name\}>/, Class.name enum)
    |> String.replace(~r/<\{description\}>/, Class.description enum)
    |> String.replace(~r/<\{properties\}>/, Enum.reduce(Class.properties(enum), "", fn
      property, acc -> acc <> PropertyGenerator.generate(state, property)
    end))
    |> (&export state, namespace, enum, &1).()
  end

  @spec export(state, namespace, enum, String.t) :: String.t | ok | error
  defp export(%{single_file: true}, _, _, content) do
    content
  end

  defp export(state, namespace, enum, content) do
    content
    |> BoilerplateGenerator.Exporter.export(namespace
      |> Namespace.name
      |> String.replace(~r/(?<=\s)App(?=\\)/, "app")
      |> String.split(~r/[\\.]/)
      |> (&[state.root_dir | &1]).()
      |> (&(&1 ++ [Class.name(enum) <> state.extension])).()
      |> Path.join
    )
  end
end
