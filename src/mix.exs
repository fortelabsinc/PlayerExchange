defmodule Playerexchange.MixProject do
  use Mix.Project

  def project do
    {:ok, vsn} = File.read("vsn.txt")

    [
      apps_path: "apps",
      version: vsn,
      start_permanent: Mix.env() == :prod,
      elixirc_options: elixirc_options(Mix.env()),
      erlc_options: erlc_options(Mix.env()),
      deps: deps(),
      releases: releases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end

  defp releases do
    [
      plyxchg: mainRelease()
    ]
  end

  defp mainRelease do
    [
      include_executables_for: [:unix],
      strip_beams: true,
      include_erts: true,
      applications: [
        runtime_tools: :permanent,
        auth: :permanent,
        storage: :permanent,
        gateway: :permanent
      ]
    ]
  end

  defp elixirc_options(:debug) do
    [debug_info: true, all_warnings: true, warnings_as_errors: true]
  end

  defp elixirc_options(_) do
    [debug_info: false, all_warnings: true, warnings_as_errors: true]
  end

  defp erlc_options(:debug) do
    [:warnings_as_errors, :debug_info]
  end

  defp erlc_options(_) do
    [:warnings_as_errors]
  end
end
