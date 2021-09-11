defmodule Postcodes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Postcodes.Repo,
      # Start the Telemetry supervisor
      PostcodesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Postcodes.PubSub},
      # Start the Endpoint (http/https)
      PostcodesWeb.Endpoint
      # Start a worker by calling: Postcodes.Worker.start_link(arg)
      # {Postcodes.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Postcodes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PostcodesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
