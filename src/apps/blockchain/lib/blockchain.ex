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
defmodule Blockchain do
  @moduledoc """
  Documentation for `Blockchain`.
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  def test do
    # wallet = %{
    #  eth_address: "0x47DDCDEBBC358288BB7B718709877A758C04E147",
    #  mnemonic_phrase:
    #    "inner silk raw stock rain chat actress theory bulb bullet vote egg zoo mutual virtual defense oppose name coil leisure leave lion blanket civil",
    #  private_key: "747912CA6B0B104D80B7021DE3C7D7A36FFF247D19CB9B9258B53FD7EF0445D1",
    #  public_key:
    #    "04FA6AD2020FDC20C595C5211723D542D3B3D1FB7512680391B09F42F99FB641579AB34E60B22751508C7AF7B35CF95B293B59B43A02C3EE51CCA73EC6B59A357A"
    # }

    ## wallet2 = ETH.Wallet.create()
    # to = "0x1513ba02f9501814B7fe3a7ab9B1D853eDD7d833"
    # ETH.send_transaction!(%{from: wallet.eth_address, to: to, value: 100_000}, wallet.private_key)
  end

  @doc """
  Creates a blockchain based account.  This will setup all the wallets assigned to the account
  and the payID account.

  Args:
  The name of the user/game/guild/etc and returns a payid account for them

  Returns:
  The payId name created
  """
  @spec createAccount(String.t()) :: {:ok, String.t()} | {:error, String.t() | atom}
  def createAccount(name) do
    name = Blockchain.Ripple.PayID.format(name)

    # Create the wallet
    with {:ok, xrpWallet} <- Blockchain.Ripple.XRP.create(),
         {:ok, ethWallet} <- Blockchain.Eth.create() do
      args = [{xrpWallet["address"], :xrp_test}, {ethWallet["address"], :eth_kovan}]

      if :ok == Blockchain.Ripple.PayID.create(name, args) do
        {:ok, _} =
          Storage.Wallet.XRP.new(xrpWallet)
          |> Storage.Wallet.XRP.write()

        {:ok, _} =
          Storage.Wallet.Eth.new(ethWallet)
          |> Storage.Wallet.Eth.write()

        # Now let's return the payid name
        {:ok, name}
      else
        {:error, "Failed to create PayID account"}
      end
    else
      err ->
        Logger.error("[Blockchain.createAccount] Error #{inspect(err)}")
        err
    end
  end

  @doc """
  Format the name into a PayID based format using the server name
  defined by the config args
  """
  @spec formatPayId(String.t()) :: String.t()
  def formatPayId(name) do
    Blockchain.Ripple.PayID.format(name)
  end

  def walletBalances(payId) do
    with {:ok, xrpAddress} <- Blockchain.Ripple.PayID.lookupAddress(payId, :xrp_test),
         {:ok, ethAddress} <- Blockchain.Ripple.PayID.lookupAddress(payId, :eth_kovan),
         {:ok, xrpBalance} <- Blockchain.Ripple.XRP.balance(xrpAddress),
         {:ok, ethBalance} <- Blockchain.Eth.balance(ethAddress) do
      xrpBalance = (String.to_integer(xrpBalance) / 1_000_000) |> Float.to_string()
      # Success.  All calls worked!
      {:ok,
       [
         %{id: "XRP", balance: xrpBalance, address: xrpAddress},
         %{id: "BTC", balance: "0", address: "Not Found"},
         %{id: "ETH", balance: ethBalance, address: ethAddress}
       ]}
    else
      err -> err
    end
  end
end
