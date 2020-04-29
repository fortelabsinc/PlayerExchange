defmodule Gateway.Router.Portal.Handler do
  require Logger

  @doc """
  """
  @spec init :: :ok
  def init() do
    Gateway.Router.Portal.Commands.Handler.Auth.init()
    :ok
  end

  @spec ping :: <<_::32>>
  def ping() do
    "auth pong"
  end
end
