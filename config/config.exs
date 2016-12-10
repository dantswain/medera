# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :medera,
  slack_api_token: System.get_env("SLACK_API_TOKEN"),
  ecto_repos: [Medera.Repo]

# Configures the endpoint
config :medera, Medera.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rF2p+RBzVdpPcDe6VMISgRuogYsdFe3gSVgZtiFNiCVYDU0mnyisd7UcjaruRyfT",
  render_errors: [view: Medera.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Medera.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
