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
defmodule Utils.Build do
  @moduledoc """
  This module basically acts as a way to define code that will be determined at
  compile time instead of runtime.  It is kind of like using config.exs values
  but can do much more like defining different function implementations, etc.

  NOTE:  PLEASE USE WITH EXTREME CAUTION

  By the nature of this code your production environments will be different
  then your dev or test builds.  However it can come in handy for defining
  mocks etc.
  """

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec if_dev([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_dev(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :dev ->
        quote do
          unquote(tBlock)
        end

      # otherwise go with the alternative
      _ ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end
    end
  end

  @doc """
  """
  @spec if_not_dev([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_not_dev(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :dev ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end

      # otherwise go with the alternative
      _ ->
        quote do
          unquote(tBlock)
        end
    end
  end

  @doc """
  """
  @spec if_prod([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_prod(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :prod ->
        quote do
          unquote(tBlock)
        end

      # otherwise go with the alternative
      _ ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end
    end
  end

  @doc """
  """
  @spec if_not_prod([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_not_prod(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :prod ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end

      # otherwise go with the alternative
      _ ->
        quote do
          unquote(tBlock)
        end
    end
  end

  @doc """
  """
  @spec if_test([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_test(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :test ->
        quote do
          unquote(tBlock)
        end

      # otherwise go with the alternative
      _ ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end
    end
  end

  @doc """
  """
  @spec if_not_test([{:do, any} | {:else, any}, ...]) :: any
  defmacro if_not_test(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :test ->
        if nil != fBlock do
          quote do
            unquote(fBlock)
          end
        end

      # otherwise go with the alternative
      _ ->
        quote do
          unquote(tBlock)
        end
    end
  end
end
