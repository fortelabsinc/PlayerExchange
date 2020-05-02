defmodule Storage.Auth.User do
  @moduledoc ~S"""
  """
  require Logger
  use Ecto.Schema

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
  # Storage.Auth.User.t  Struct definition and accessors
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
  """
  @spec confirmaID(Storage.Auth.User.t()) :: String.t()
  def confirmaID(userT), do: userT.confirm_id

  @doc """
  """
  @spec confirmed(Storage.Auth.User.t()) :: boolean()
  def confirmed(userT), do: userT.confirmed

  @doc """
  """
  @spec email(Storage.Auth.User.t()) :: String.t()
  def email(userT), do: userT.email

  @doc """
  """
  @spec regDate(Storage.Auth.User.t()) :: NativeDateTime.t()
  def regDate(userT), do: userT.inserted_at

  @doc """
  """
  @spec meta(Storage.Auth.User.t()) :: map
  def meta(userT), do: userT.meta

  @doc """
  """
  @spec passResetExpires(Storage.Auth.User.t()) :: nil | integer()
  def passResetExpires(userT), do: userT.password_reset_expire

  @doc """
  """
  @spec passResetKey(Storage.Auth.User.t()) :: nil | integer()
  def passResetKey(userT), do: userT.password_reset_key

  @doc """
  """
  @spec loginCount(Storage.Auth.User.t()) :: integer()
  def loginCount(userT), do: userT.successful_login_attemps

  @doc """
  """
  @spec lastUpdate(Storage.Auth.User.t()) :: NativeDateTime.t()
  def lastUpdate(userT), do: userT.update_at

  @doc """
  """
  @spec userID(Storage.Auth.User.t()) :: String.t()
  def userID(userT), do: userT.user_id

  @doc """
  """
  @spec userName(Storage.Auth.User.t()) :: String.t()
  def userName(userT), do: userT.username

  # ----------------------------------------------------------------------------
  # Access Pass Wrappers
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec check(any) :: {:error, <<_::160>>} | {:ok, any}
  def check(token), do: AccessPass.logged?(token)

  @doc """
  """
  @spec refresh(any) :: any
  def refresh(token), do: AccessPass.refresh(token)

  @doc """
  """
  @spec register(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any}
  def register(data), do: AccessPass.register(data)

  @doc """
  """
  @spec confirm(any) :: {:error, <<_::200>>} | {:ok, any}
  def confirm(id), do: AccessPass.confirm(id)

  @doc """
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
  """
  @spec logout(any) :: any
  def logout(token), do: AccessPass.logout(token)

  @doc """
  """
  @spec resetPassword(any) :: {:error, <<_::256>>} | {:ok, <<_::296>>}
  def resetPassword(user), do: AccessPass.reset_password(user)

  @doc """
  """
  @spec changePassword(any, any, any) ::
          {:ok} | {:error, <<_::256>> | %{optional(atom) => [binary]}}
  def changePassword(id, pass, passConf), do: AccessPass.change_password(id, pass, passConf)

  @doc """
  """
  @spec forgotUserName(any) :: {:error, <<_::152>>} | {:ok, <<_::256>>}
  def forgotUserName(email), do: AccessPass.forgot_username(email)

  # ----------------------------------------------------------------------------
  # Query Operations
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec queryAll :: [Storage.Auth.User.t()]
  def queryAll() do
    Storage.Repo.all(Storage.Auth.User)
  end

  @doc """
  """
  @spec queryByName(String.t()) :: nil | Storage.Auth.User.t()
  def queryByName(name) do
    Storage.Repo.get_by(Storage.Auth.User, username: name)
  end

  @doc """
  """
  @spec queryByEmail(String.t()) :: nil | Storage.Auth.User.t()
  def queryByEmail(email) do
    Storage.Repo.get_by(Storage.Auth.User, email: email)
  end

  @doc """
  """
  @spec queryById(String.t()) :: nil | Storage.Auth.User.t()
  def queryById(id) do
    Storage.Repo.get_by(Storage.Auth.User, user_id: id)
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

  # ----------------------------------------------------------------------------
  # Private Helpers
  # ----------------------------------------------------------------------------
  defp getMeta(nil), do: %{}
  defp getMeta(map), do: Map.get(map, "meta", %{})
end
