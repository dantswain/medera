defmodule Medera do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    token = Application.get_env(:medera, :slack_api_token)
    IO.puts("TOKEN IS #{inspect token}")
    unless token do
      raise "You must specify a Slack API tocken"
    end

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Medera.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Medera.Endpoint, []),
      worker(Medera.MessageProducer, [token]),
      worker(Medera.Printer, [], id: 1),
      worker(Medera.Printer, [], id: 2),
      worker(Medera.Connector, [token]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Medera.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Medera.Endpoint.config_change(changed, removed)
    :ok
  end
end
