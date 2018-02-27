defmodule BoilerplateGenerator.ClassProperty do
  alias CodeParserState.Property, as: Property

  @type state :: BoilerplateGenerator.state
  @type property :: Property.property

  @public_template File.read! Application.get_env(:boilerplate_generator, :public_property, "templates/public_property.tmpl")
  @private_template File.read! Application.get_env(:boilerplate_generator, :private_property, "templates/private_property.tmpl")

  @spec generate(state, property) :: String.t
  def generate(state, property) do
    find_template(state, property)
    |> String.replace(~r/<\{description\}>/, Property.description property)
    |> String.replace(~r/<\{accessibility\}>/, Property.accessibility property)
    |> String.replace(~r/<\{type\}>/, Property.type property)
    |> String.replace(~r/<\{name\}>/, Property.name property)
  end

  @spec find_template(state, property) :: String.t
  defp find_template(state, %{accessibility: accessibility}) do
    case Regex.match?(~r/public/, accessibility) do
      true -> BoilerplateGenerator.find_template(state, :class_public_property_template, @public_template)
      _ -> BoilerplateGenerator.find_template(state, :class_private_property_template, @private_template)
    end
  end
end
