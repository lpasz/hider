import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :hider, Hider.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "hider_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hider, HiderWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RHVPbT3/qTvs0O9zI8MR8RqN0Oj6xwR5P4QyTxCO6q7Q1ULzCD5nsiptZXJyVibq",
  server: false

# In test we don't send emails.
config :hider, Hider.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Only for test env
config :bcrypt_elixir, log_rounds: 1

# config/test.exs
config :my_app, Oban, queues: false, plugins: false
