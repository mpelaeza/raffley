# Raffley

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker

Requiere una base de datos PostgreSQL accesible. Seteá estas env vars o el proyecto usará defaults localhost/root/postgres/raffley_dev.

```sh
# Build y arrancar
docker compose up -d

# Setup DB (crear, migrar, seeds)
docker compose exec app mix ecto.setup

# O solo seeds
docker compose exec app mix run priv/repo/seeds.exs

# Logs
docker compose logs -f app

# Detener
docker compose down
```

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
