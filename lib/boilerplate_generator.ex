defmodule BoilerplateGenerator do

  @type code_parser_state :: CodeParserState.state
  @type state :: %BoilerplateGenerator{
    extension: String.t,
    code_parser_state: code_parser_state,
    root_dir: String.t,
    force_overwrite: boolean,
    class_template: String.t,
    interface_template: String.t,
    enum_template: String.t,
    public_property_template: String.t,
    private_property_template: String.t,
    method_template: String.t,
    interface_property_template: String.t,
    interface_method_template: String.t,
    enum_property_template: String.t,
    single_file: boolean,
    result: String.t
  }
  @type option :: {:root, String.t}
    | {:extension, String.t}
    | {:force_overwrite, boolean}
    | {:class_template, String.t}
    | {:interface_template, String.t}
    | {:enum_template, String.t}
    | {:public_property_template, String.t}
    | {:private_property_template, String.t}
    | {:method_template, String.t}
    | {:interface_property_template, String.t}
    | {:interface_method_template, String.t}
    | {:enum_property_template, String.t}
    | {:single_file, boolean}
  @type options :: [option]

  @class_template File.read! "templates/class.tmpl"
  @enum_template File.read! "templates/enum.tmpl"
  @enum_property_template File.read! "templates/enum_property.tmpl"
  @interface_template File.read! "templates/interface.tmpl"
  @interface_method_template File.read! "templates/interface_method.tmpl"
  @interface_property_template File.read! "templates/interface_property.tmpl"
  @method_template File.read! "templates/method.tmpl"
  @public_property_template File.read! "templates/public_property.tmpl"
  @private_property_template File.read! "templates/private_property.tmpl"

  defstruct code_parser_state: %CodeParserState{},
    extension: ".gen",
    root_dir: "",
    force_overwrite: false,
    class_template: "",
    interface_template: "",
    enum_template: "",
    public_property_template: "",
    private_property_template: "",
    method_template: "",
    interface_property_template: "",
    interface_method_template: "",
    enum_property_template: "",
    single_file: false,
    result: ""

  @spec generate(code_parser_state, options) :: :ok
  def generate(code_parser_state, opts \\ []) do
    %BoilerplateGenerator{code_parser_state: code_parser_state}
    |> parse_options(opts)
    |> BoilerplateGenerator.File.generate_from_files
  end

  @spec parse_options(state, options) :: state
  defp parse_options(state, options) do
    state
    |> Map.put(:extension, Keyword.get(options, :extension, ".gen"))
    |> Map.put(:class_template, Keyword.get(options, :class_template, @class_template))
    |> Map.put(:enum_template, Keyword.get(options, :enum_template, @enum_template))
    |> Map.put(:enum_property_template, Keyword.get(options, :enum_property_template, @enum_property_template))
    |> Map.put(:interface_template, Keyword.get(options, :interface_template, @interface_template))
    |> Map.put(:interface_method_template, Keyword.get(options, :interface_method_template, @interface_method_template))
    |> Map.put(:interface_property_template, Keyword.get(options, :interface_property_template, @interface_property_template))
    |> Map.put(:method_template, Keyword.get(options, :method_template, @method_template))
    |> Map.put(:public_property_template, Keyword.get(options, :public_property_template, @public_property_template))
    |> Map.put(:private_property_template, Keyword.get(options, :private_property_template, @private_property_template))
    |> Map.put(:single_file, Keyword.get(options, :single_file, false))
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
