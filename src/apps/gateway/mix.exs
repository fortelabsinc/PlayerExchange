defmodule Gateway.MixProject do
  use Mix.Project

  def project do
    {:ok, vsn} = File.read("../../vsn.txt")

    [
      app: :gateway,
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
      mod: {Gateway.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:auth, in_umbrella: true},
      {:utils, in_umbrella: true},
      {:storage, in_umbrella: true},
      {:blockchain, in_umbrella: true},
      {:game, in_umbrella: true},
      {:cowboy, "~> 2.7", override: true},
      {:plug_cowboy, "~> 2.2"},
      {:uuid, "~> 1.1"},
      {:jason, "~> 1.2"},
      {:plug, git: "https://github.com/fortelabsinc/plug.git", branch: "master", override: true},
      {:corsica, "~> 1.1"},
      {:ex_json_schema, "~> 0.7.4"}
    ]
  end
end
