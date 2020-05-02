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
  ecto_repos: [Storage.Repo]

config :access_pass, AccessPass.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: "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"

config :access_pass,
  repo: Storage.Repo,
  from: "cjimison@gmail.com"

config :access_pass, overrides_module: Storage.Auth.EmailTemplate
