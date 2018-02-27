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

  @template File.read! Application.get_env(:boilerplate_generator, :enum_template, "templates/enum.tmpl")

  @spec generate(state, namespace, enum) :: ok | error
  def generate(state, namespace, enum) do
    BoilerplateGenerator.find_template(state, :enum_template, @template)
    |> String.replace(~r/<\{namespace\}>/, Namespace.name namespace)
    |> String.replace(~r/<\{name\}>/, Class.name enum)
    |> String.replace(~r/<\{description\}>/, Class.description enum)
    |> String.replace(~r/<\{properties\}>/, Enum.reduce(Class.properties(enum), "", fn
      property, acc -> acc <> PropertyGenerator.generate(state, property)
    end))
    |> BoilerplateGenerator.Exporter.export(namespace
      |> Namespace.name
      |> String.split(".")
      |> (&[state.root_dir | &1]).()
      |> (&(&1 ++ [Class.name(enum) <> ".cs"])).()
      |> Path.join
    )
  end
end
