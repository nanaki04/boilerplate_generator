defmodule BoilerplateGenerator do

  @type code_parser_state :: CodeParserState.state
  @type state :: %BoilerplateGenerator{
    code_parser_state: code_parser_state,
    root_dir: String.t,
    force_overwrite: boolean,
    class_template: String.t,
    interface_template: String.t,
    enum_template: String.t,
    class_public_property_template: String.t,
    class_private_property_template: String.t,
    class_method_template: String.t,
    interface_property_template: String.t,
    interface_method_template: String.t,
    enum_property_template: String.t,
  }
  @type option :: {:root, String.t}
    | {:force_overwrite, boolean}
    | {:class_template, String.t}
    | {:interface_template, String.t}
    | {:enum_template, String.t}
    | {:class_public_property_template, String.t}
    | {:class_private_property_template, String.t}
    | {:class_method_template, String.t}
    | {:interface_property_template, String.t}
    | {:interface_method_template, String.t}
    | {:enum_property_template, String.t}
  @type options :: [option]

  defstruct code_parser_state: %CodeParserState{},
    root_dir: "",
    force_overwrite: false,
    class_template: "",
    interface_template: "",
    enum_template: "",
    class_public_property_template: "",
    class_private_property_template: "",
    class_method_template: "",
    interface_property_template: "",
    interface_method_template: "",
    enum_property_template: ""

  @spec generate(code_parser_state, options) :: :ok
  def generate(code_parser_state, opts \\ []) do
    %BoilerplateGenerator{code_parser_state: code_parser_state}
    |> parse_options(opts)
    |> BoilerplateGenerator.File.generate_from_files
  end

  @spec parse_options(state, options) :: state
  defp parse_options(state, _opts) do
    # TODO
    state
  end

  @spec find_template(state, atom, String.t) :: String.t
  def find_template(state, key, default) do
    case Map.fetch(state, key) do
      {:ok, ""} -> default
      {:ok, path} -> File.read(path)
        |> (fn
          {:ok, file} -> file
          _ -> default
        end).()
      _ -> default
    end
  end
end
