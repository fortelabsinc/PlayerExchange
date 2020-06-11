# MIT License
#
# Copyright (c) 2020 forte labs inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
  require Logger
  import Ecto.Query

  use Ecto.Repo,
    otp_app: :storage,
    adapter: Ecto.Adapters.Postgres

  # ----------------------------------------------------------------------------
  # Public Node APIs
  # ----------------------------------------------------------------------------

  @doc """
  Called by Ecto to setup the repo with the passed in keyword args
  """
  @spec init(term, keyword) :: {:ok, keyword}
  def init(_, opts) do
    {:ok, buildOpts(opts)}
  end

  @doc """
  Get the current NaiveDateTime in UTC capped at seconds
  """
  @spec timestamps :: NaiveDateTime.t()
  def timestamps() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end

  @doc """
  Get a page out of a table.  This is kind of a generic solution
  so all the pages for the different tables so we can have the
  same container structure setup for each display
  """
  @spec page(term, String.t() | number, String.t() | number) :: map
  def page(query, page, count) when is_binary(page) do
    page = String.to_integer(page)
    page(query, page, count)
  end

  def page(query, page, count) when is_binary(count) do
    count = String.to_integer(count)
    page(query, page, count)
  end

  def page(query, page, count) do
    num = count + 1

    result =
      query
      |> limit(^count)
      |> offset(^(page * count))
      |> Storage.Repo.all()

    total_count = Storage.Repo.one(from(t in subquery(query), select: count("*")))
    part_count = (page + 1) * count
    has_next = length(result) == count and part_count < total_count
    has_prev = page > 0

    nextPage = if has_next, do: page + 1, else: -1
    idx = page * count + 1

    %{
      next: has_next,
      prev: has_prev,
      last_page: page - 1,
      next_page: nextPage,
      page: page,
      first_idx: idx,
      last_idx: Enum.min([idx + count, total_count]),
      count: total_count,
      list: Enum.slice(result, 0, num - 1)
    }
  end

  @doc """
  Create the fields for the change set info that is NOT encrypted

  NOTE: This API is setupto be a helper for ecto based changelist
        please read up on them before modifying this code
  """
  @spec changeSetField(any, atom, any) :: any
  def changeSetField(fields, _key, nil), do: fields

  def changeSetField(fields, key, val), do: Map.put(fields, key, val)

  @doc """
  Create the fields for the change set info that is encrypted

  NOTE: This API is setupto be a helper for ecto based changelist
        please read up on them before modifying this code
  """
  @spec changeSetEncryptedField(any, atom, any) :: any
  def changeSetEncryptedField(fields, _key, nil), do: fields

  def changeSetEncryptedField(fields, key, val),
    do: Map.put(fields, key, Utils.Crypto.encrypt(val) |> Base.encode64())

  # --------------------------------------------------------------------------
  # Private Functions
  # --------------------------------------------------------------------------

  # Pull the database connection info from environment variables instead of
  # the config file.
  #
  # TODO:  Make this pull the config file as a default option here
  defp buildOpts(opts) do
    [
      database:
        System.get_env("PLYXCH_DB", Application.get_env(:storage, :ecto_db, "storage_repo")),
      username: System.get_env("PLYXCH_DB_USER", Application.get_env(:storage, :ecto_us, "root")),
      password:
        System.get_env(
          "PLYXCH_DB_PASS",
          Application.get_env(:storage, :ecto_pa, "dbpassword")
        ),
      hostname:
        System.get_env("PLYXCH_DB_HOST", Application.get_env(:storage, :ecto_host, "localhost")),
      port: System.get_env("PLYXCH_DB_PORT", "26257") |> String.to_integer()
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
