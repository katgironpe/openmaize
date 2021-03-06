defmodule Mix.Tasks.Openmaize.Gen.Ectodb do
  use Mix.Task

  @moduledoc """
  Create modules for tasks that use Ecto to call the database.
  """

  @doc false
  def run(_) do
    mod_name = Openmaize.Utils.base_name
    srcdir = Path.join [Application.app_dir(:openmaize, "priv"), "templates", "database"]

    files = [{"openmaize_ecto.ex", "web/models/openmaize_ecto.ex"},
     {"openmaize_ecto_test.exs", "test/models/openmaize_ecto_test.exs"}]

    Mix.Openmaize.copy_files(srcdir, files, mod_name)
    |> instructions
  end

  @doc false
  def instructions(oks) do
    if :ok in oks do
      Mix.shell.info """

      Please check the generated files. Certain details in them, such as
      paths, user details, roles, etc., will most likely need to be
      changed.

      See the documentation for Openmaize.Config for further details
      on how to configure Openmaize.
      """
    else
      Mix.shell.info """

      No files have been installed.
      """
    end
  end
end
