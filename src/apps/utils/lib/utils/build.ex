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
  Compiler macro that will only add the do block code if it is a dev build
  and will run the else block of code if it is something else (test or prod)

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_dev do
    @msg "I am a dev build"
  else
    @msg "I am NOT a dev build"
  end

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

  defmacro if_dev(do: tBlock) do
    if :dev == Mix.env() do
      quote do
        unquote(tBlock)
      end
    end
  end

  @doc """
  Compiler macro that will only add the do block code if it is not a dev build
  (test or prod) and will run the else block of code if it is a dev build

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_not_dev do
    @msg "I am NOT a dev build"
  else
    @msg "I am a dev build"
  end

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

  defmacro if_not_dev(do: tBlock) do
    if :dev != Mix.env() do
      # If this is a dev block
      quote do
        unquote(tBlock)
      end
    end
  end

  @doc """
  Compiler macro that will only add the do block code if it is a prod build
  and will run the else block of code if it is something else (test or dev)

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_prod do
    @msg "I am a prod build"
  else
    @msg "I am NOT a prod build"
  end

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

  defmacro if_prod(do: tBlock) do
    if :prod == Mix.env() do
      quote do
        unquote(tBlock)
      end
    end
  end

  @doc """
  Compiler macro that will only add the do block code if it is not a prod build
  (test or dev) and will run the else block of code if it is a prod build

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_not_prod do
    @msg "I am NOT a prod build"
  else
    @msg "I am a prod build"
  end

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

  defmacro if_not_prod(do: tBlock) do
    if :prod != Mix.env() do
      # If this is a dev block
      quote do
        unquote(tBlock)
      end
    end
  end

  @doc """
  Compiler macro that will only add the do block code if it is a test build
  and will run the else block of code if it is something else (prod or dev)

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_test do
    @msg "I am a test build"
  else
    @msg "I am NOT a test build"
  end

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
  defmacro if_test(do: tBlock) do
    if :test == Mix.env() do
      quote do
        unquote(tBlock)
      end
    end
  end

  @doc """
  Compiler macro that will only add the do block code if it is not a test build
  (prod or dev) and will run the else block of code if it is a test build

  Note:  the else block is optional

  ## Example:
  import Utils.Build

  if_not_test do
    @msg "I am NOT a test build"
  else
    @msg "I am a test build"
  end

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

  defmacro if_not_test(do: tBlock) do
    if :test != Mix.env() do
      # If this is a dev block
      quote do
        unquote(tBlock)
      end
    end
  end
end
