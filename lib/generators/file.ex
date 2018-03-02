defmodule BoilerplateGenerator.File do

  @type state :: BoilerplateGenerator.state
  @type ok :: BoilerplateGenerator.Exporter.ok
  @type error :: BoilerplateGenerator.Exporter.error

  @spec generate_from_files(state) :: ok | error
  def generate_from_files(%{single_file: true} = state) do
    state.code_parser_state.files
    |> Enum.reduce(state, fn file, state -> generate_from_file(state, file) end)
    |> wrap_file_template
    |> Map.fetch!(:result)
    |> String.replace(~r/(?<=^)\n/, "")
    |> BoilerplateGenerator.Exporter.export(state.root_dir <> "/export" <> state.extension)
  end

  def generate_from_files(state) do
    state.code_parser_state.files
    |> Enum.map(fn file -> generate_from_file(state, file) end)
    |> (fn _ -> :ok end).()
  end

  @spec generate_from_file(state, CodeParserState.File.file) :: ok | String.t
  def generate_from_file(%{single_file: true} = state, file) do
    file.namespaces
    |> Enum.reduce(state, fn namespace, state -> BoilerplateGenerator.Namespace.generate_from_namespace(state, namespace) end)
  end

  def generate_from_file(state, file) do
    file.namespaces
    |> Enum.map(fn namespace ->
      Task.async(fn -> BoilerplateGenerator.Namespace.generate_from_namespace(state, namespace) end)
    end)
    |> Enum.map(&Task.await/1)
    |> (fn _ -> :ok end).()
  end

  @spec wrap_file_template(state) :: state
  defp wrap_file_template(%{file_template: ""} = state), do: state

  defp wrap_file_template(%{file_template: file_template} = state) do
    Map.update! state, :result, &String.replace(file_template, ~r/<\{file\}>/, &1)
  end
end
