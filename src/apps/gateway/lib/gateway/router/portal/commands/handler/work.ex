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
defmodule Gateway.Router.Portal.Commands.Handler.Work do
  @moduledoc ~S"""
  Processes the HTTP based requests and sends them to the correct handler.

  The handler or business logic is broken out of http request so I can
  change API versions later on but still keep backwards compatability
  support if possible
  """

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  @doc """
  Basic setup.  Nothing to do here
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @doc """
  Get all the postings

  """
  @spec postings() :: {:ok, any}
  def postings() do
    data = [
      %{
        post_id: UUID.uuid4(),
        user_id: UUID.uuid4(),
        meta: %{},
        game_id: "World of Warcraft",
        details: "I need some help completing the quest FOOBAR.  Should take about 1 hour.",
        state: "open",
        confirm_pay_type: "XRP",
        confirm_pay_amt: "100",
        complete_pay_type: "XRP",
        complete_pay_amt: "100",
        bonus_pay_type: "XRP",
        bonus_pay_amt: "100",
        bonus_req: "If we can finish it up in under and hour",
        user_count_req: 1,
        type_req: "individual"
      },
      %{
        post_id: UUID.uuid4(),
        user_id: UUID.uuid4(),
        meta: %{},
        game_id: "Call of Duty",
        details: "Looking for some to help teach me.",
        state: "open",
        confirm_pay_type: "XRP",
        confirm_pay_amt: "100",
        complete_pay_type: "XRP",
        complete_pay_amt: "100",
        bonus_pay_type: "XRP",
        bonus_pay_amt: "100",
        bonus_req: "I get a kill in a live game",
        user_count_req: 3,
        type_req: "group"
      },
      %{
        post_id: UUID.uuid4(),
        user_id: UUID.uuid4(),
        meta: %{},
        game_id: "7 Days to Die",
        details: "I need someone to guard my base from 1pm - 4pm.",
        state: "open",
        confirm_pay_type: "XRP",
        confirm_pay_amt: "500",
        complete_pay_type: "XRP",
        complete_pay_amt: "500",
        bonus_pay_type: "XRP",
        bonus_pay_amt: "500",
        bonus_req: "No one breaks into the base",
        user_count_req: 3,
        type_req: "group"
      }
    ]

    {:ok, data}
  end
end
