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
defmodule Storage.Work.Guild do
  @moduledoc ~S"""
  Jobs board postings data management.  All this data will be stored in ecto.
  """
  require Logger
  use Ecto.Schema
  import Ecto.Query

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------
  @doc """
  Job Posting definition.  This is the record type that will be written/read
  from the database.
  """
  @primary_key false
  schema "guilds" do
    field(:name, :string)
    field(:payid, :string)
    field(:meta, :map)
    timestamps(type: :naive_datetime, autogenerate: {Storage.Repo, :timestamps, []})
  end

  # ----------------------------------------------------------------------------
  # Storage.Auth.Posting.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Work.Guild{
          name: String.t(),
          payid: String.t(),
          meta: map,
          inserted_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @doc """
  Reads out a page from the system.  This is showing ALL
  guilds in the system
  """
  @spec queryPage(non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Work.Guild.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryPage(page, count) do
    rez =
      Storage.Work.Guild
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  defp parsePage(data), do: data
end
