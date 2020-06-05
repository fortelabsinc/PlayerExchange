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
defmodule UtilsTest do
  @moduledoc """
  Unit test for the file:  utils/lib/utils.ex
  """
  use ExUnit.Case
  doctest Utils

  # Make sure build version format follows our schema
  test "Build Version Test" do
    buildVsn = Utils.buildVersion() |> String.split(".") |> Enum.map(&String.to_integer/1)
    assert length(buildVsn) == 3, "Build version format is incorrect"
  end

  # Test that the hash is set
  test "Build Hash Test" do
    buildHash = Utils.buildHash()
    assert is_bitstring(buildHash), "Build hash format is incorrect"
  end

  test "UUID Tests" do
    uuid = Utils.uuid4()
    inOut = Utils.uuidToBinary(uuid) |> Utils.uuidToString()
    assert uuid == inOut

    uuid = Utils.uuid4(:binary)
    inOut = Utils.uuidToString(uuid) |> Utils.uuidToBinary()
    assert uuid == inOut
  end
end
