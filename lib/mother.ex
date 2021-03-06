defmodule Mother do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Mother.Endpoint, []),
      # Here you could define other workers and supervisors as children
      # worker(Mother.Worker, [arg1, arg2, arg3]),
      worker(Mother.Database, [[host: "localhost", port: 28015, db: "mother"]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mother.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Mother.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Mother.Database do
  use RethinkDB.Connection
end
