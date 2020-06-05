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
defmodule Utils.Build.Test do
  @moduledoc """
  Unit test for the file:  utils/lib/utils/build.ex
  """

  use ExUnit.Case
  doctest Utils
  import Utils.Build

  test "Basic Test Based Compiler test" do
    # NOTE: we can only test this stuff out for test
    #       and we have to trust it works for prod/dev

    if_test do
      msg = "test"
    else
      msg = "BAD"
    end

    if_not_test do
      notMsg = "BAD2"
    else
      notMsg = "test2"
    end

    if_test do
      singleMsg = :set
    end

    notSingleMsg = nil

    if_not_test do
      notSingleMsg = :set
    end

    assert msg == "test", "if_test failed"
    assert notMsg == "test2", "if_not_test failed"

    assert singleMsg == :set, "Single If statment not working"
    assert notSingleMsg == nil, "Single If Not statment not working"
  end

  test "Basic Dev Based Compiler test" do
    # NOTE: we can only test this stuff out for test
    #       and we have to trust it works for prod/dev

    if_dev do
      msg = "BAD"
    else
      msg = "test"
    end

    if_not_dev do
      notMsg = "test2"
    else
      notMsg = "BAD2"
    end

    singleMsg = :set

    if_dev do
      singleMsg = nil
    end

    if_not_dev do
      notSingleMsg = :set
    end

    assert msg == "test", "if_dev failed"
    assert notMsg == "test2", "if_not_dev failed"

    assert singleMsg == :set, "Single If statment not working"
    assert notSingleMsg == :set, "Single If Not statment not working"
  end

  test "Basic Prod Based Compiler test" do
    # NOTE: we can only test this stuff out for test
    #       and we have to trust it works for prod/dev

    if_prod do
      msg = "BAD"
    else
      msg = "test"
    end

    if_not_prod do
      notMsg = "test2"
    else
      notMsg = "BAD2"
    end

    singleMsg = :set

    if_prod do
      singleMsg = nil
    end

    if_not_prod do
      notSingleMsg = :set
    end

    assert msg == "test", "if_prod failed"
    assert notMsg == "test2", "if_not_prod failed"

    assert singleMsg == :set, "Single If statment not working"
    assert notSingleMsg == :set, "Single If Not statment not working"
  end
end
