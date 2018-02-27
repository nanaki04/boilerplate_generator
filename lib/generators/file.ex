defmodule BoilerplateGenerator.File do

  def generate_from_files(state) do
    state.code_parser_state.files
    |> Enum.map(fn file -> generate_from_file(state, file) end)
    |> (fn _ -> :ok end).()
  end

  def generate_from_file(state, file) do
    file.namespaces
    |> Enum.map(fn namespace ->
      Task.async(fn -> BoilerplateGenerator.Namespace.generate_from_namespace(state, namespace) end)
    end)
    |> Enum.map(&Task.await/1)
    |> (fn _ -> :ok end).()
  end
end
