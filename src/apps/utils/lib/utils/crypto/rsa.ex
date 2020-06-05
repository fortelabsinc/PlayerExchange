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
defmodule Utils.Crypto.RSA do
  @moduledoc """
  Basic wrapper over the :public_key api.  Please read up on how public key
  encryption works in general before using this lib
  """

  # ----------------------------------------------------------------------------
  # Module Types
  # ----------------------------------------------------------------------------

  @type t :: %{private: any, public: any}

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Encrypt some data using the public key info.  The key info
  should come from the new API
  """
  @spec encryptPublic(String.t(), Utils.Crypto.RSA.t()) :: binary
  def encryptPublic(text, %{public: key}) do
    :public_key.encrypt_public(text, key)
  end

  @doc """
  Encrypt some data using the private key info.  The key info
  should come from the new API
  """
  @spec encryptPrivate(String.t(), Utils.Crypto.RSA.t()) :: binary
  def encryptPrivate(text, %{private: key}) do
    :public_key.encrypt_private(text, key)
  end

  @doc """
  Decrypt some data using the Public key info.  This info is assumed
  to have been encrypted with the private key version of this data
  """
  @spec decryptPublic(String.t(), Utils.Crypto.RSA.t()) :: String.t()
  def decryptPublic(text, %{public: key}) do
    :public_key.decrypt_public(text, key)
  end

  @doc """
  Decrypt some data using the Private key info.  This info is assumed
  to have been encrypted with the public key version of this data
  """
  @spec decryptPrivate(String.t(), Utils.Crypto.RSA.t()) :: String.t()
  def decryptPrivate(text, %{private: key}) do
    :public_key.decrypt_private(text, key)
  end

  @doc """
  Convert a string version of a RSA Key into a format that the
  :public_key module can use
  """
  @spec decodeKey(String.t()) :: any
  def decodeKey(text) do
    [entry] = :public_key.pem_decode(text)
    :public_key.pem_entry_decode(entry)
  end

  @doc """
  Check to see if the key is in a valid format.boolean()
  NOTE: This check is not the best in the world right
        now because it just does the decode and inspects
        the results.  I wonder if there is a faster way
        to do this.
  """
  def valid?(text), do: [] != :public_key.pem_decode(text)

  @doc """
  Create a new public key info map based on the string representation
  of the RSA key
  """
  @spec new(String.t(), nil | String.t()) :: Utils.Crypto.RSA.t()
  def new(publicKeyText, nil) do
    %{
      private: nil,
      public: decodeKey(publicKeyText)
    }
  end

  def new(publicKeyText, privateKeyText) do
    %{
      private: decodeKey(privateKeyText),
      public: decodeKey(publicKeyText)
    }
  end

  @doc """
  Create a new public/private key pair structure
  This API is typically used with the `generate`
  function

  """
  @spec new({String.t(), String.t()}) :: Utils.Crypto.RSA.t()
  def new({publicKeyText, privateKeyText}) do
    %{
      private: decodeKey(privateKeyText),
      public: decodeKey(publicKeyText)
    }
  end

  @doc """
  Create a RSA Key Pair.  Note:  This call is a
  bit expensive because you have to to call openssl
  directly from the OS, then read/write the output

  NOTE: This code is a bit scary because it is leaving keys
        on the file system if for example something
        fails but it should be OK given that the info
        can not be used until AFTER the files are deleted
        but still I don't like have a public record of these

        In the future it would be good to look into creating
        these keys without using the commandline openssl.

  Returns:

  {publicKeyText, privateKeyText}
  """
  @spec generate(String.t()) ::
          {String.t(), String.t()}
  def generate(bits \\ "2048") do
    keyName = UUID.uuid4()
    priKey = "#{keyName}_priv.pem"
    pubKey = "#{keyName}_pub.pem"

    {_, 0} = System.cmd("openssl", ["genrsa", "-out", priKey, bits], stderr_to_stdout: true)

    {_, 0} =
      System.cmd(
        "openssl",
        ["rsa", "-pubout", "-in", priKey, "-out", pubKey],
        stderr_to_stdout: true
      )

    {:ok, priv} = File.read(priKey)
    {:ok, pub} = File.read(pubKey)

    File.rm!(priKey)
    File.rm!(pubKey)

    {pub, priv}
  end

  @doc """
  Sign message with RSA private key
  """
  @spec sign(String.t(), Utils.Crypto.RSA.t(), atom) :: String.t()
  def sign(message, %{private: key}, digestType \\ :sha256) do
    :public_key.sign(message, digestType, key)
  end

  @doc """
  Verify signature with RSA public key
  """
  @spec verify(String.t(), binary, Utils.Crypto.RSA.t(), atom) :: boolean
  def verify(message, signature, %{public: key}, digestType \\ :sha256) do
    :public_key.verify(message, digestType, signature, key)
  end
end
