defmodule Utils.MixProject do
  use Mix.Project

  def project do
    {:ok, vsn} = File.read("../../vsn.txt")

    [
      app: :utils,
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:uuid, "~> 1.1"},
      {:argon2_elixir, "~> 2.3"},
      {:comeonin, "~> 5.3.1", override: true}
    ]
  end
end
