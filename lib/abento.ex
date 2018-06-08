defmodule Abento do
  use Application
  require Logger

  def start(_type, _args) do
    # init...
    pod = System.get_env("MY_POD_IP")
    Logger.info(fn -> "pod ip is : #{pod}" end)

    # DB
    Logger.info("Starting the database...")
    Amnesia.start()
    Database.create()
    Abento.DB.populate()

    # supervisor
    Logger.info("Starting supervisor...")
    port = Application.get_env(:plug_ex, :cowboy_port, 8000)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Abento.Router, [], port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
