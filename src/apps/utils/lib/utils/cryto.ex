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
defmodule Utils.Crypto do
  @moduledoc ~S"""
  This is my basic crypto wrapper for encoding/decoding any amount of text data.
  This module will use AES 256 Bit Keys for Encryption so it should be pretty
  locked down.
  """

  # ----------------------------------------------------------------------------
  # Module Consts
  # ----------------------------------------------------------------------------
  # Use AES 256 Bit Keys for Encryption.
  @aad "AES256GCM"

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Encrypt some block of text data.  Assuming everything worked as planned
  it should return the encrypted binary.  These methods will encrypt the data
  using the applications keys
  """
  @spec encrypt(String.t() | charlist()) :: binary
  def encrypt(plaintext) do
    iv = :crypto.strong_rand_bytes(16)
    # get latest key
    key = getKey()
    # get latest ID;
    key_id = getKeyId()
    # {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {@aad, plaintext, 16})
    {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {@aad, to_string(plaintext), 16})
    iv <> tag <> <<key_id::unsigned-big-integer-32>> <> ciphertext
  end

  @doc """
  Decrypt some text that was encrypted via the call to `Utils.Crypto.encrypt`
  """
  @spec decrypt(binary) :: :error | String.t()
  def decrypt(ciphertext) do
    <<iv::binary-16, tag::binary-16, key_id::unsigned-big-integer-32, ciphertext::binary>> =
      ciphertext

    :crypto.block_decrypt(:aes_gcm, getKey(key_id), iv, {@aad, ciphertext, tag})
  end

  @doc """
  A fash hash of the data (using Sha256).  This is good for simple things
  like an email hash, etc but not good for things like passwords, etc
  """
  @spec hash(String.t()) :: String.t()
  def hash(data) do
    :crypto.hash(:sha256, data) |> Base.encode64()
  end

  @doc """
  This creates a strong hash of the data passed in.  It is much slower
  to generate and should be used for things like passwords, etc.
  """
  @spec hashStrong(String.t()) :: String.t()
  def hashStrong(data) do
    Argon2.Base.hash_password(data, Argon2.gen_salt(), [{:argon2_type, 2}])
  end

  @doc """
  verifies if the data passed in matches the hash value pulled out.
  This can be used to say validated that passwords in the system etc.
  """
  @spec hashStrongVerify(String.t(), String.t()) :: boolean()
  def hashStrongVerify(data, hash) do
    Argon2.verify_pass(data, hash)
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  # Pull out the most current key
  defp getKey do
    getKeyId() |> getKey
  end

  # pull out a specific key
  defp getKey(key_id) do
    encryptionKeys()
    |> Enum.at(key_id)
  end

  # Get the last key id
  defp getKeyId do
    Enum.count(encryptionKeys()) - 1
  end

  defp encryptionKeys do
    Application.get_env(:utils, :keys)
  end
end
