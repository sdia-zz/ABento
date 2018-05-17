defmodule Abento do
  use Application
  require Logger

  def start(_type, _args) do

    port = Application.get_env(:plug_ex, :cowboy_port, 8000)
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Abento.Router, [], port: port)
    ]

    Logger.info("Application started!")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
