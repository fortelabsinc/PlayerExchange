defmodule Gateway.Router.Portal.Commands.Handler.Auth do
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
end
