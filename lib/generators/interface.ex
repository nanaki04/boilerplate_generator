defmodule BoilerplateGenerator.Interface do
  alias CodeParserState.Namespace, as: Namespace
  alias CodeParserState.Interface, as: Interface
  alias CodeParserState.Class, as: Class
  alias BoilerplateGenerator.InterfaceProperty, as: PropertyGenerator
  alias BoilerplateGenerator.InterfaceMethod, as: MethodGenerator

  @type state :: BoilerplateGenerator.state
  @type namespace :: %Namespace{}
  @type interface :: %Interface{}
  @type ok :: BoilerplateGenerator.Exporter.ok
  @type error :: BoilerplateGenerator.Exporter.error

  @spec generate(state, namespace, interface) :: ok | error
  def generate(state, namespace, interface) do
    state.interface_template
    |> String.replace(~r/<\{namespace\}>/, Namespace.name namespace)
    |> String.replace(~r/<\{name\}>/, Class.name interface)
    |> String.replace(~r/<\{description\}>/, Class.description interface)
    |> String.replace(~r/<\{properties\}>/, Enum.reduce(Class.properties(interface), "", fn
      property, acc -> acc <> PropertyGenerator.generate(state, property)
    end))
    |> String.replace(~r/<\{methods\}>/, Enum.reduce(Class.methods(interface), "", fn
      method, acc -> acc <> MethodGenerator.generate(state, method)
    end))
    |> BoilerplateGenerator.Exporter.export(namespace
      |> Namespace.name
      |> String.split(".")
      |> (&[state.root_dir | &1]).()
      |> (&(&1 ++ [Class.name(interface) <> ".cs"])).()
      |> Path.join
    )
  end
end
