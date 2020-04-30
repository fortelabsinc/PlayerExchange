defmodule Gateway.Router.Portal.Handler do
  require Logger

  @doc """
  """
  @spec init :: :ok
  def init() do
    Gateway.Router.Portal.Commands.Handler.Auth.init()
    :ok
  end
end
