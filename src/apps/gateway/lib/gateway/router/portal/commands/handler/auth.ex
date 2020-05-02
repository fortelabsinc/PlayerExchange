defmodule Gateway.Router.Portal.Commands.Handler.Auth do
  @moduledoc """
  For the most part we are just pushing these requests off to the
  storage module.  While one can argue that the storage module should
  not be responsible for such actions, AccessPass is a library used
  to do most of the auth actions.  AccessPass has both a mix of storage
  and business logic to manage auth.  As such we are just going to
  make use of this module however storage is main interface for it so ...
  """
  require Logger

  @doc """
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @spec ping :: <<_::32>>
  def ping() do
    "pong"
  end

  @doc """
  """
  @spec check(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def check(accessToken), do: Storage.Auth.User.check(accessToken)

  @doc """
  """
  @spec refresh(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def refresh(refreshToken), do: Storage.Auth.User.refresh(refreshToken)

  @doc """
  """
  @spec register(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any}
  def register(data), do: Storage.Auth.User.register(data)

  @doc """
  """
  @spec confirm(any) :: {:error, <<_::200>>} | {:ok, any}
  def confirm(confirmId) do
    case Storage.Auth.User.confirm(confirmId) do
      {:ok, _} = rsp ->
        ## Lets create an XRP Wallet
        # {:ok, info} = Blockchain.Ripple.XRP.create()
        ## Now let's create a PayID for this user
        # payID = "foobar"
        # wallet = info.address

        # :ok =
        #  Blockchain.Ripple.PayID.client()
        #  |> Blockchain.Ripple.PayID.create(payID, wallet)
        rsp

      rsp ->
        rsp
    end
  end

  @doc """
  """
  @spec login(String.t(), String.t()) :: {:error, <<_::200, _::_*64>>} | {:ok, map}
  def login(username, password), do: Storage.Auth.User.login(username, password)

  @doc """
  """
  @spec logout(any) :: any
  def logout(accessToken), do: Storage.Auth.User.logout(accessToken)

  @doc """
  """
  @spec resetPassword(any) :: {:error, <<_::256>>} | {:ok, <<_::296>>}
  def resetPassword(user), do: Storage.Auth.User.resetPassword(user)

  @doc """
  """
  @spec changePassword(any, any, any) ::
          {:ok} | {:error, <<_::256>> | %{optional(atom) => [binary]}}
  def changePassword(id, pass, passConf), do: Storage.Auth.User.changePassword(id, pass, passConf)

  @doc """
  """
  @spec forgotUsername(any) :: {:error, <<_::152>>} | {:ok, <<_::256>>}
  def forgotUsername(email), do: Storage.Auth.User.forgotUserName(email)
end
