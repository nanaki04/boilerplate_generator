defmodule BoilerplateGenerator.EnumProperty do
  alias CodeParserState.Property, as: Property

  @type state :: BoilerplateGenerator.state
  @type property :: Property.property

  @spec generate(state, property) :: String.t
  def generate(state, property) do
    state.enum_property_template
    |> String.replace(~r/<\{name\}>/, Property.name property)
    |> String.replace(~r/<\{description\}>/, Property.description property)
  end
end
