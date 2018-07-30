use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wiki_node_nav, WikiNodeNavWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wiki_node_nav, WikiNodeNav.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wiki_node_nav_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
