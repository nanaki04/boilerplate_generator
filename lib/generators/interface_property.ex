defmodule BoilerplateGenerator.InterfaceProperty do
  alias CodeParserState.Property, as: Property

  @type state :: BoilerplateGenerator.state
  @type property :: Property.property

  @spec generate(state, property) :: String.t
  def generate(state, property) do
    state.interface_property_template
    |> String.replace(~r/<\{accessibility\}>/, Property.accessibility property)
    |> String.replace(~r/<\{description\}>/, Property.description property)
    |> String.replace(~r/<\{type\}>/, Property.type property)
    |> String.replace(~r/<\{name\}>/, Property.name property)
  end
end
