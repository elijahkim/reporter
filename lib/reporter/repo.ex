defmodule Reporter.Repo do
  use Ecto.Repo,
    otp_app: :reporter,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
