defmodule Utils.Build do
  @moduledoc """
  Documentation for `Utils`.
  """

  @doc """
  """
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
            unquote(tBlock)
          end
        end
    end
  end

  @doc """
  """
  defmacro if_not_dev(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :dev ->
        if nil != fBlock do
          quote do
            unquote(tBlock)
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
            unquote(tBlock)
          end
        end
    end
  end

  @doc """
  """
  defmacro if_not_prod(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :prod ->
        if nil != fBlock do
          quote do
            unquote(tBlock)
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
            unquote(tBlock)
          end
        end
    end
  end

  @doc """
  """
  defmacro if_not_test(do: tBlock, else: fBlock) do
    case Mix.env() do
      # If this is a dev block
      :test ->
        if nil != fBlock do
          quote do
            unquote(tBlock)
          end
        end

      # otherwise go with the alternative
      _ ->
        quote do
          unquote(tBlock)
        end
    end
  end

  def hello(), do: :world
end
