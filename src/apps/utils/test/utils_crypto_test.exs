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
defmodule Utils.Crypto.Test do
  use ExUnit.Case
  require Logger
  doctest Utils

  test "Basic Encrypt/Decrypt Test" do
    msg = Utils.uuid4()

    res = Utils.Crypto.encrypt(msg)
    assert msg != res, "Encryption did not actual encrypt the data"

    res = Utils.Crypto.decrypt(res)
    assert msg == res, "Decrypt did not work"
  end

  test "Basic Hash Testing" do
    msg = UUID.uuid4()
    msg2 = UUID.uuid4()
    hash = Utils.Crypto.hash(msg)
    hash2 = Utils.Crypto.hash(msg2)

    assert msg != hash, "Hash did not return something that is a hash"
    assert hash2 != hash, "multiple hash match.  That is not good"
  end

  test "Basic Strong Hash Testing" do
    msg = UUID.uuid4()
    msg2 = UUID.uuid4()
    hash = Utils.Crypto.hashStrong(msg)
    hash2 = Utils.Crypto.hashStrong(msg2)

    assert msg != hash, "Strong Hash did not return something that is a hash"
    assert hash2 != hash, "multiple Strong hash match.  That is not good"

    # Now let's verify
    assert Utils.Crypto.hashStrongVerify(msg, hash), "Strong hash could not validate info"
    assert Utils.Crypto.hashStrongVerify(msg2, hash2), "Strong hash could not validate info"

    assert false == Utils.Crypto.hashStrongVerify(msg2, hash),
           "Strong hash validated incorrectly"
  end
end
