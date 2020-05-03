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

config :storage,
  ecto_repos: [Storage.Repo],
  database: System.get_env("PLYXCH_DB_HOST", "localhost")

config :access_pass, AccessPass.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: System.get_env("SEND_GRID_KEY")

config :access_pass,
  repo: Storage.Repo,
  from: "forte@playerexchange.io"

config :access_pass, overrides_module: Storage.Auth.EmailTemplate
