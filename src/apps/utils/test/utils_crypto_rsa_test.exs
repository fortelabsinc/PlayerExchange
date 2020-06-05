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
defmodule Utils.Crypto.RSA.Test do
  use ExUnit.Case
  require Logger
  doctest Utils

  test "General Tests" do
    # Generate a key for the tests to use
    # NOTE: Utils.Crypt.RSA is using the decodeKey api
    #       so it is not explicity tested
    keys =
      Utils.Crypto.RSA.generate()
      |> Utils.Crypto.RSA.new()

    msg = "This is a test message"

    # Run the basic sign/verify check
    signature = Utils.Crypto.RSA.sign(msg, keys)
    assert Utils.Crypto.RSA.verify(msg, signature, keys), "signature verify failed"

    # Let's try encrypting and decrypting with the public key
    rez =
      Utils.Crypto.RSA.encryptPublic(msg, keys)
      |> Utils.Crypto.RSA.decryptPrivate(keys)

    assert(msg == rez, "pub/priv encrypted/decrypted results do not match")

    # Let's try encrypting and decrypting with the private key
    rez =
      Utils.Crypto.RSA.encryptPrivate(msg, keys)
      |> Utils.Crypto.RSA.decryptPublic(keys)

    assert(msg == rez, "priv/pub encrypted/decrypted results do not match")
  end

  # In the case where the developer gives us a single public key I want to
  # test encoding/decoding data with it
  test "Single Key based encode/decode" do
    {pub, priv} = Utils.Crypto.RSA.generate()
    keys = Utils.Crypto.RSA.new(pub, priv)
    key = Utils.Crypto.RSA.new(pub, nil)

    # Let's sign something with the private key and make sure we can decode it
    # with the public key

    msg = "Yet another test message"
    enc = Utils.Crypto.RSA.encryptPrivate(msg, keys)
    rsp = Utils.Crypto.RSA.decryptPublic(enc, key)
    assert rsp == msg, "Private Encode/Decode loop did not work"

    enc = Utils.Crypto.RSA.encryptPublic(msg, key)
    rsp = Utils.Crypto.RSA.decryptPrivate(enc, keys)

    assert rsp == msg, "Public Encode/Decode loop did not work"

    # Let's test the signature when I only have the public key to
    # verify it
    signature = Utils.Crypto.RSA.sign(msg, keys)
    assert Utils.Crypto.RSA.verify(msg, signature, key), "signature verify failed"
  end
end
