defmodule Postcodes.Repo do
  use Ecto.Repo,
    otp_app: :postcodes,
    adapter: Ecto.Adapters.Postgres
end
