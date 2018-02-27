defmodule BoilerplateGenerator.EnumProperty do
  alias CodeParserState.Property, as: Property

  @type state :: BoilerplateGenerator.state
  @type property :: Property.property

  @template File.read! Application.get_env(:boilerplate_generator, :enum_property_template, "templates/enum_property.tmpl")

  @spec generate(state, property) :: String.t
  def generate(state, property) do
    BoilerplateGenerator.find_template(state, :enum_property_template, @template)
    |> String.replace(~r/<\{name\}>/, Property.name property)
  end
end
