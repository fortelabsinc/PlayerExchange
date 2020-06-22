defmodule Game.MixProject do
  use Mix.Project

  def project do
    {:ok, vsn} = File.read("../../vsn.txt")

    [
      app: :game,
      version: vsn,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Game.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:blockchain, in_umbrella: true},
      {:storage, in_umbrella: true},
      {:utils, in_umbrella: true}
    ]
  end
end
