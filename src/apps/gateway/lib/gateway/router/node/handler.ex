defmodule Gateway.Router.Node.Handler do
  require Logger

  @doc """
  """
  @spec init :: :ok
  def init() do
    # Create a ets table that we will use to store of some data
    :gateway_node_status = :ets.new(:gateway_node_status, [:named_table, :set, :public])
    true = :ets.insert(:gateway_node_status, {:health_state, true})
    true = :ets.insert(:gateway_node_status, {:health_delay, 0})
    :ok
  end

  @spec ping :: <<_::32>>
  def ping() do
    "pong"
  end

  @doc """
  Checks to see if anything has marked this node as unhealth.
  If the node is marked as unhealth, it will delay some amount
  of time before it responds based on the value passed in.  This
  is mostly so we can kill a node via a simple http request if
  so needed.

  TODO:

  This storage info should be refactored into the storage module
  but for now this will do.
  """
  @spec healthy :: boolean()
  def healthy() do
    [health_state: state] = :ets.lookup(:gateway_node_status, :health_state)

    if not state do
      [health_delay: val] = :ets.lookup(:gateway_node_status, :health_delay)

      if val > 0 do
        Process.sleep(2000)
      end
    end

    # Return the value
    state
  end

  @doc """
  Set the state of the heath check variable
  """
  @spec setHealthyState(boolean()) :: :ok | {:error, String.t()}
  def setHealthyState(val) do
    true = :ets.insert(:gateway_node_status, {:health_state, val})
    :ok
  end

  @doc """
  Set the amount of time the healthy check should delay
  """
  @spec setHealthyDelay(integer()) :: :ok | {:error, String.t()}
  def setHealthyDelay(val) do
    true = :ets.insert(:gateway_node_status, {:health_delay, val})
    :ok
  end

  @doc """
  Check to see if the application is ready to start accepting incoming requests
  """
  @spec ready() :: boolean()
  def ready(), do: true
end
