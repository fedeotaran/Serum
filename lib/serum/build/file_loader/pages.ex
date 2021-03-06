defmodule Serum.Build.FileLoader.Pages do
  @moduledoc false

  _moduledocp = "A module for loading pages from a project."

  require Serum.Result, as: Result
  import Serum.Build.FileLoader.Common
  import Serum.IOProxy, only: [put_msg: 2]
  alias Serum.Plugin.Client, as: PluginClient

  @doc false
  @spec load(binary()) :: Result.t([Serum.File.t()])
  def load(src) do
    put_msg(:info, "Loading page files...")

    pages_dir = get_subdir(src, "pages")

    if File.exists?(pages_dir) do
      [pages_dir, "**", "*.{md,html,html.eex}"]
      |> Path.join()
      |> Path.wildcard()
      |> PluginClient.reading_pages()
      |> case do
        {:ok, files} -> read_files(files)
        {:error, _} = plugin_error -> plugin_error
      end
    else
      Result.fail(POSIX: [:enoent], file: %Serum.File{src: pages_dir})
    end
  end
end
