defmodule Muttkraft.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Muttkraft.Repo,
      # Start the Telemetry supervisor
      MuttkraftWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Muttkraft.PubSub},
      # Start the Endpoint (http/https)
      MuttkraftWeb.Endpoint
      # Start a worker by calling: Muttkraft.Worker.start_link(arg)
      # {Muttkraft.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Muttkraft.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MuttkraftWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
