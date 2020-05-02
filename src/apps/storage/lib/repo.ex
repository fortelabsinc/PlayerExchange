defmodule Storage.Repo do
  @moduledoc """
  Setup Ecto to use the cockroachDB adapter and link it to the
  storage app.  The config values should use to direct which DB
  to connect to should be pulled from the environment variables first,
  and if the environment variable is not set, it will pull it from
  the config file, finally just use some default values of:

  default database:   storage_repo
  default username:   root
  default password:   dbpassword
  default hostname:   database
  default port:       26257
  """

  use Ecto.Repo,
    otp_app: :storage,
    adapter: Ecto.Adapters.CockroachDB

  @doc """
  Called by Ecto to setup the repo with the passed in keyword args
  """
  @spec init(term, keyword) :: keyword
  def init(_, opts) do
    {:ok, buildOpts(opts)}
  end

  # --------------------------------------------------------------------------
  # Private Functions
  # --------------------------------------------------------------------------

  # Pull the database connection info from environment variables instead of
  # the config file.
  #
  # TODO:  Make this pull the config file as a default option here
  defp buildOpts(opts) do
    [
      database: System.get_env("EMP_DATABASE", "storage_repo"),
      username: System.get_env("EMP_DATABASE_USER_NAME", "root"),
      password: System.get_env("EMP_DATABASE_USER_PASSWORD", "dbpassword"),
      hostname: System.get_env("EMP_DATABASE_HOST", "localhost"),
      port: System.get_env("EMP_DATABASE_PORT", "26257") |> String.to_integer()
    ]
    |> removeEmptyOpts()
    |> mergeOpts(opts)
  end

  # Basically just a wrapper ove rthe keyword list merge
  defp mergeOpts(system_opts, opts) do
    Keyword.merge(opts, system_opts)
  end

  # Remove any nil value options
  defp removeEmptyOpts(system_opts) do
    Enum.reject(system_opts, fn {_k, value} -> is_nil(value) end)
  end
end
