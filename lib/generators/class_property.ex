defmodule BoilerplateGenerator.ClassProperty do
  alias CodeParserState.Property, as: Property

  @type state :: BoilerplateGenerator.state
  @type property :: Property.property

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
      true -> state.public_property_template
      _ -> state.private_property_template
    end
  end
end
