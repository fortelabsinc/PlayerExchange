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
defmodule Storage.Auth.EmailTemplate do
  @moduledoc """
  When we send an email to the user we want to format it in a way
  that makes has the correct info.  This module is defined to manage
  that account creation and access
  """
  use AccessPassBehavior
  import Utils.Build

  # ----------------------------------------------------------------------------
  # Module Consts
  # ----------------------------------------------------------------------------
  if_prod do
    @schema "https"
    @port "443"
    @server "forte.playerexchange.io"
  else
    @schema "http"
    @port "8180"
    @server "localhost"
  end

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Called by accesspass to create the email template that gets sentout to users
  """
  @spec confirmation_email() :: String.t()
  def confirmation_email() do
    """
    <a href="#{@schema}://#{@server}:#{@port}/portal/commands/v1/auth/confirm?confirm_id=<%= conf_key %>">Please confirm you access</a>
    """
  end
end
