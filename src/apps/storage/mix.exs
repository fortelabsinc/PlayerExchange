defmodule Storage.MixProject do
  use Mix.Project

  def project do
    [
      app: :storage,
      version: "0.1.0",
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
      mod: {Storage.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:comeonin, "~> 5.3.1", override: true},
      {:plug, git: "https://github.com/fortelabsinc/plug.git", branch: "master", override: true},
      {:bamboo, "~> 1.5.0", override: true},
      {:access_pass, git: "https://github.com/fortelabsinc/accesspass.git"},
      {:utils, in_umbrella: true},
      {:ecto, "~> 3.4"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, "~> 0.15.4"}
    ]
  end
end
