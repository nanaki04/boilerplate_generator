defmodule BoilerplateGenerator.Decorator do
  @type t :: module
  @type code_parser_state :: CodeParserState.state
  @type contents :: String.t

  @callback transform_input(code_parser_state) :: code_parser_state
  @callback transform_output(contents) :: contents
end
