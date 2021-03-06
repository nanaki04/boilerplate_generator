defmodule BoilerplateGenerator.InterfaceMethod do
  alias CodeParserState.Method, as: Method

  @type state :: BoilerplateGenerator.state
  @type method :: Method.method

  @spec generate(state, method) :: String.t
  def generate(state, method) do
    state.interface_method_template
    |> String.replace(~r/<\{accessibility\}>/, Method.accessibility method)
    |> String.replace(~r/<\{description\}>/, Method.description method)
    |> String.replace(~r/<\{type\}>/, Method.type method)
    |> String.replace(~r/<\{name\}>/, Method.name method)
    |> String.replace(~r/<\{parameters\}>/, Enum.map(Method.parameters(method), fn
      parameter -> parameter.type <> " " <> parameter.name
    end) |> Enum.join(", "))
    |> String.replace(~r/<\{property docs\}>/, Enum.reduce(Method.parameters(method), "", fn
      parameter, acc -> acc <> "\n        /// <param name=\"" <> parameter.name <> "\"></param>"
    end))
  end
end
