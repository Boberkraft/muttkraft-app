defmodule Muttkraft.Repo do
  use Ecto.Repo,
    otp_app: :muttkraft,
    adapter: Ecto.Adapters.Postgres
end
