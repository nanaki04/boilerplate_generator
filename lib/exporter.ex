defmodule BoilerplateGenerator.Exporter do
  alias BoilerplateGenerator.Decorator, as: Decorator

  @type file :: String.t
  @type path :: String.t
  @type ok :: :ok
  @type error :: {:error, term}

  @spec export(file, path) :: ok | error
  def export(file, path) do
    path = case String.match?(path, ~r/(?<=^)\/[\w.]+(?=$)/) do
      true -> String.slice path, 1..String.length(path)
      _ -> path
    end
    path
    |> String.replace(~r/[\w\.]+(?=$)/, "")
    |> case() do
      "" -> :ok
      dir -> File.mkdir_p(dir)
    end
    |> write_file(file, path)
  end

  @spec decorate(Decorator.contents, [Decorator.t]) :: Decorator.contents
  def decorate(file, decorators) do
    Enum.reduce(decorators, file, fn decorator, file ->
      decorator.transform_output(file)
    end)
  end

  @spec write_file(ok | error, file, path) :: ok | error
  defp write_file({:error, _reason}, _, path) do
    IO.puts("ERROR: failed to make dir \"" <> path <> "\"")
    {:error, :failed_to_make_dir}
  end

  defp write_file(:ok, file, path) do
    File.write(path, file)
    |> (fn
      {:error, _} ->
        IO.puts("ERROR: failed to write file \"" <> path <> "\"")
        {:error, :failed_to_write_file}
      :ok ->
        IO.puts("Generated file: " <> path)
        :ok
    end).()
  end
end
