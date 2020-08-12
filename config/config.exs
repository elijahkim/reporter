# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :reporter,
  ecto_repos: [Reporter.Repo]

# Configures the endpoint
config :reporter, ReporterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SuViyYA6rla48m/HzmdRMBVt/hEnlhYn9G823LQ/kGlr7zbgXh4Plhq8t2o/5g4O",
  render_errors: [view: ReporterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Reporter.PubSub,
  live_view: [signing_salt: "ff6dlTYA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
