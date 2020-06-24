# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# config :ethereumex,
#  url: "https://kovan.infura.io/v3/bd759a8d4ecb45eaa6376cf022beeb9d"

defaultHost =
  if :dev == Mix.env() or :test == Mix.env() do
    # Generate a random key to use
    key =
      :crypto.strong_rand_bytes(32)
      |> Base.encode64()

    # Now dump it into the environment var
    System.put_env("PLYXCHG_APP_KEYS", key)

    # I find it eaiser to just reuse a dummy key
    System.put_env("PLYXCHG_APP_KEYS", "8q26WVwPp/NdFMMKnKKTBPaLpnxiD+Untm6EuggN2hw=")

    # And return the default cockroach host.
    # NOTE:  I need to clean this up
    "localhost"
  else
    System.get_env("PLYXCHG_DB_HOST", "localhost")
  end

# OK, if no environment vars are found bail out
if nil == System.get_env("PLYXCHG_APP_KEYS", nil) do
  raise "Environment Variable not found PLYXCHG_APP_KEYS"
end

defaultNamespace = "forte-player-exchange-dev"
defaultPayIdDomain = "dev.playerexchange.io"

config :blockchain,
  namespace: System.get_env("PLYXCHG_NAMESPACE", defaultNamespace)
  payid_domain: System.get_env("PLYXCHG_PAY_ID_DOMAIN", defaultPayIdDomain)

config :storage,
  ecto_repos: [Storage.Repo],
  ecto_host: System.get_env("PLYXCHG_DB_HOST", defaultHost)
  ecto_user: System.get_env("PLYXCH_DB_USER", "root")
  ecto_pass: System.get_env("PLYXCH_DB_PASS", "pass")
  ecto_port: System.get_env("PLYXCH_DB_PORT", "26257")

config :access_pass, AccessPass.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: System.get_env("SEND_GRID_KEY")

config :access_pass,
  repo: Storage.Repo,
  from: "forte@playerexchange.io",
  access_expire_in: 144_000,
  refresh_expire_in: 144_000,
  overrides_module: Storage.Auth.EmailTemplate

config :utils,
  keys:
    System.get_env("PLYXCHG_APP_KEYS")
    # remove single-quotes around key list in .env
    |> String.replace("'", "")
    # split the CSV list of keys
    |> String.split(",")
    |> Enum.map(fn key -> Base.decode64!(key) end),
  build_hash: System.get_env("GITHUB_SHA", "1234")

# Lets include in build specific keys.
# import_config("#{Mix.env()}.exs"
