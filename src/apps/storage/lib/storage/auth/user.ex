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
defmodule Storage.Auth.User do
  @moduledoc ~S"""
  This module will mange the basic access to the state data for a user.
  The format of this table is based on the requirements around access_pass.
  """
  require Logger
  use Ecto.Schema
  import Ecto.Query

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  This is the basic user table as defined by the access pass system.
  For now this is kind of considered hands off until I fork access
  pass and fix up some of the APIs, etc to better fit my needs
  """
  @primary_key false
  schema "users" do
    field(:user_id, :string, primary_key: true)
    field(:username, :string)
    field(:meta, :map)
    field(:email, :string)
    field(:password_hash, :string)
    field(:successful_login_attempts, :integer)
    field(:confirm_id, :string)
    field(:password_reset_key, :string)
    field(:password_reset_expire, :integer)
    field(:confirmed, :boolean)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  # ----------------------------------------------------------------------------
  # Storage.Auth.User.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Auth.User{
          confirm_id: String.t(),
          confirmed: boolean,
          email: String.t(),
          inserted_at: NativeDateTime.t(),
          meta: map,
          password_hash: String.t(),
          password_reset_expire: nil | integer(),
          password_reset_key: nil | integer(),
          successful_login_attempts: integer(),
          updated_at: NativeDateTime.t(),
          user_id: String.t(),
          username: String.t()
        }

  @doc """
  Storage.Auth.User.t accessor to the confirmation ID for a user
  """
  @spec confirmaID(Storage.Auth.User.t()) :: String.t()
  def confirmaID(userT), do: userT.confirm_id

  @doc """
  Storage.Auth.User.t accessor if this user has been "confirmed"
  via an email verification check
  """
  @spec confirmed(Storage.Auth.User.t()) :: boolean()
  def confirmed(userT), do: userT.confirmed

  @doc """
  Storage.Auth.User.t accessor to the email for a user
  """
  @spec email(Storage.Auth.User.t()) :: String.t()
  def email(userT), do: userT.email

  @doc """
  Storage.Auth.User.t accessor to the date when the user
  registered their account
  """
  @spec regDate(Storage.Auth.User.t()) :: NativeDateTime.t()
  def regDate(userT), do: userT.inserted_at

  @doc """
  Storage.Auth.User.t accessor to the meta data for a user.
  This is a map structure that will be saved in JSON in the DB
  """
  @spec meta(Storage.Auth.User.t()) :: map
  def meta(userT), do: userT.meta

  @doc """
  Set the meta field for this user struct.  Note:  this will
  not change the database value.  You will need to write this
  struct later.
  """
  @spec setMeta(Storage.Auth.User.t(), map) :: Storage.Auth.User.t()
  def setMeta(userT, meta) do
    %{userT | meta: meta}
  end

  @doc """
  Storage.Auth.User.t accessor password reset expire date.

  NOTE:

  This is an internal field to access pass and it is unknown
  what this field is actually used for and what the format
  of the value is
  """
  @spec passResetExpires(Storage.Auth.User.t()) :: nil | integer()
  def passResetExpires(userT), do: userT.password_reset_expire

  @doc """
  Storage.Auth.User.t accessor password reset key generated
  when a reset command is given.
  """
  @spec passResetKey(Storage.Auth.User.t()) :: nil | integer()
  def passResetKey(userT), do: userT.password_reset_key

  @doc """
  Storage.Auth.User.t accessor for the number of times
  a user has logged into the system.
  """
  @spec loginCount(Storage.Auth.User.t()) :: integer()
  def loginCount(userT), do: userT.successful_login_attemps

  @doc """
  Storage.Auth.User.t accessor for the last time that
  the given user updated their profile.

  NOTE:

  This is managed by access_pass so it is unknown what actions
  actually trigger this value to change.  For example: does
  a login attempt update this field because it updates the
  loginCount? This is unknown at this time
  """
  @spec lastUpdate(Storage.Auth.User.t()) :: NativeDateTime.t()
  def lastUpdate(userT), do: userT.update_at

  @doc """
  Storage.Auth.User.t accessor for the userID
  """
  @spec userID(Storage.Auth.User.t()) :: String.t()
  def userID(userT), do: userT.user_id

  @doc """
  Storage.Auth.User.t accessor for the userName
  """
  @spec userName(Storage.Auth.User.t()) :: String.t()
  def userName(userT), do: userT.username

  # ----------------------------------------------------------------------------
  # Access Pass Wrappers
  # ----------------------------------------------------------------------------

  @doc """
  Check to see if a session token is valid.  This call will talk to accesspass
  which stores this info inside an ETS table and should be pretty fast.
  """
  @spec check(any) :: {:error, <<_::160>>} | {:ok, any}
  def check(token), do: AccessPass.logged?(token)

  @doc """
  Refresh an existing session token with accesspass. This call will talk to
  accesspass which stores this info inside an ETS table and should be pretty
  fast.
  """
  @spec refresh(any) :: any
  def refresh(token), do: AccessPass.refresh(token)

  @doc """
  Registeres a new user in the system.  This will talk to AccessPass to send out
  and email for confirmation in general.  This will need to talk to the DB
  so it should be considered a more expensive call.
  """
  @spec register(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any}

  def register(data), do: AccessPass.register(data)

  @doc """
  This is the same as the register version but for dev env.  Basically
  this will not send an email but will return the confirmID so
  it can be handled on the server side
  """
  @spec registerDev(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any, String.t()}

  def registerDev(data), do: AccessPass.no_email_register(data)

  @doc """
  Confirms a Registration token that was sent to a users email address.
  This call will need to do both Read and Writes to the DB via AccessPass
  """
  @spec confirm(any) :: {:error, <<_::200>>} | {:ok, any}
  def confirm(id), do: AccessPass.confirm(id)

  @doc """
  Verifies the login info for a user.  This will talk to AccessPass
  and will require a DB Read (to pull the data) and a Write if the attempt
  was successful, etc.
  """
  @spec login(any, any) :: {:error, <<_::200, _::_*64>>} | {:ok, map}
  def login(username, password) do
    case AccessPass.login(username, password) do
      {:ok, map} ->
        # TODO:
        # Lets pull out the meta data.  This should really
        # be returned as part of the login.
        {:ok, Map.put(map, "meta", Storage.Auth.User.queryMetaByName(username))}

      e ->
        e
    end
  end

  @doc """
  Logs out a user from the system.  This will expire the given session token
  from the system.
  """
  @spec logout(any) :: any
  def logout(token), do: AccessPass.logout(token)

  @doc """
  Request to reset the password for a user.  This is done via AccessPass
  and it is unclear of the cost of said operation at this time.
  """
  @spec resetPassword(any) :: {:error, <<_::256>>} | {:ok, <<_::296>>}
  def resetPassword(user), do: AccessPass.reset_password(user)

  @doc """
  Request to change the password for a given user.  This will require
  both DB reads and writes and can be considered an expensive operation.
  """
  @spec changePassword(any, any, any) ::
          {:ok} | {:error, <<_::256>> | %{optional(atom) => [binary]}}
  def changePassword(id, pass, passConf), do: AccessPass.change_password(id, pass, passConf)

  @doc """
  Request to get the username.  This will cause a email to fire off
  via Accesspass.  It is unknown to the cost of this function.
  """
  @spec forgotUserName(any) :: {:error, <<_::152>>} | {:ok, <<_::256>>}
  def forgotUserName(email), do: AccessPass.forgot_username(email)

  # ----------------------------------------------------------------------------
  # Query Operations
  # ----------------------------------------------------------------------------

  @doc """
  Pull all the users from the system.  The cost of this call will grow with the
  total number of users in the system.  It will require a DB read
  """
  @spec queryAll :: [Storage.Auth.User.t()]
  def queryAll() do
    Storage.Repo.all(Storage.Auth.User)
  end

  @doc """
  Pulls a User recorded based on the given name.  This will require a DB operation
  however it will only pull the one record
  """
  @spec queryByName(String.t()) :: nil | Storage.Auth.User.t()
  def queryByName(name) do
    Storage.Repo.get_by(Storage.Auth.User, username: name)
  end

  @doc """
  Pulls a User recorded based on the given email address.  This will require a
  DB operation however it will only pull the one record
  """
  @spec queryByEmail(String.t()) :: nil | Storage.Auth.User.t()
  def queryByEmail(email) do
    Storage.Repo.get_by(Storage.Auth.User, email: email)
  end

  @doc """
  Pulls a User recorded based on the given user id.  This will require a
  DB operation however it will only pull the one record
  """
  @spec queryById(String.t()) :: nil | Storage.Auth.User.t()
  def queryById(id) do
    Storage.Repo.get_by(Storage.Auth.User, user_id: id)
  end

  @doc """
  Pulls a User recorded based on the given user confirmation id.  This will
  require a DB operation however it will only pull the one record
  """
  @spec queryByConfirmId(String.t()) :: nil | Storage.Auth.User.t()
  def queryByConfirmId(id) do
    Storage.Repo.get_by(Storage.Auth.User, confirm_id: id)
  end

  @doc """
  Read the Meta data field from the users database who matches the given username

  Note: You should use this API if you are sure the user exists.  Otherwise
        you will just get back an empty map and not know if the map was empty
        due to the player not existing OR if the user just has an empty map

  # Arguments:

  name = The string username of record to pull meta

  # Returns

  %{} map of the meta field


  TODO:
  This is currently pulling the full record when really I just
  want the meta field.  Need to profile and see if it is actually
  more performant to eat the network bandwidth and serialization
  time verses say just asking for the single field
  """
  @spec queryMetaByName(String.t()) :: %{}
  def queryMetaByName(name) do
    Storage.Repo.get_by(Storage.Auth.User, username: name)
    |> getMeta()
  end

  @doc """
  Read the Meta data field from the users database who matches the given email

  Note: You should use this API if you are sure the user exists.  Otherwise
        you will just get back an empty map and not know if the map was empty
        due to the player not existing OR if the user just has an empty map

  # Arguments:

  name = The string email of record to pull meta

  # Returns

  %{} map of the meta field.  Empty map if not found

  TODO:
  This is currently pulling the full record when really I just
  want the meta field.  Need to profile and see if it is actually
  more performant to eat the network bandwidth and serialization
  time verses say just asking for the single field
  """
  @spec queryMetaByEmail(String.t()) :: %{}
  def queryMetaByEmail(email) do
    Storage.Repo.get_by(Storage.Auth.User, email: email)
    |> getMeta()
  end

  @doc """
  Read the Meta data field from the users database who matches the given user ID

  # Arguments:

  id = The string id of record to pull meta

  Note: You should use this API if you are sure the user exists.  Otherwise
        you will just get back an empty map and not know if the map was empty
        due to the player not existing OR if the user just has an empty map

  # Returns

  %{} map of the meta field

  TODO:
  This is currently pulling the full record when really I just
  want the meta field.  Need to profile and see if it is actually
  more performant to eat the network bandwidth and serialization
  time verses say just asking for the single field
  """
  @spec queryMetaById(String.t()) :: Storage.Auth.User.t()
  def queryMetaById(id) do
    Storage.Repo.get_by(Storage.Auth.User, user_id: id)
    |> getMeta()
  end

  @doc """
  Reads out a page from the system.  This is showing ALL
  order from all app
  """
  @spec queryPage(non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Auth.User.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryPage(page, count) do
    rez =
      Storage.Auth.User
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  @doc """
  Get all the guild names
  """
  @spec queryNames([String.t()]) :: {:ok, map} | {:error, any}
  def queryNames(userIds) do
    query =
      from(g in "users",
        where: g.user_id in ^userIds,
        select: {g.user_id, g.username}
      )

    case Storage.Repo.all(query) do
      nil ->
        {:ok, %{}}

      data ->
        rez =
          Enum.reduce(data, %{}, fn {id, name}, acc ->
            Map.put(acc, id, name)
          end)

        {:ok, rez}
    end
  end

  # ----------------------------------------------------------------------------
  # Write Operations
  # ----------------------------------------------------------------------------
  @doc """
  Write a record back to the database.  This is a wholistic write the idea being
  you read the whole record, modify some fields and write the data back to
  the system.

  ```
  Storage.Auth.User.queryById(id)
  |> Storage.Auth.User.setMeta(%{:name => "hello"})
  |> Storage.Auth.User.write
  ```
  """
  @spec write(Storage.Auth.User.t()) ::
          {:ok, Storage.Auth.User.t()} | {:error, any()}
  def write(user), do: Storage.Repo.insert(user)

  @doc """
  Create an Ecto changeset to write the meta data
  """
  @spec changeMeta(
          {map, map} | %{:__struct__ => atom | %{__changeset__: any}, optional(atom) => any},
          any
        ) :: Ecto.Changeset.t()
  def changeMeta(user, data) do
    Ecto.Changeset.change(user, meta: data)
  end

  @doc """
  Write all the changes to the database
  """
  @spec change(Ecto.Changeset.t()) ::
          {:ok, Storage.Auth.User.t()} | {:error, any()}
  def change(changeset) do
    Storage.Repo.update(changeset)
  end

  # ----------------------------------------------------------------------------
  # Private Helpers
  # ----------------------------------------------------------------------------
  defp getMeta(nil), do: %{}
  defp getMeta(map), do: Map.get(map, "meta", %{})

  defp parsePage(data), do: data
end
