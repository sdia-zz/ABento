defmodule Abento.Router do
  use Plug.Router
  require Logger


  plug :match
  plug :dispatch


  get "/" do
    send_resp(conn, 200, "Abento api")
  end

  match _, do: send_resp(conn, 404, "Not found :-)!")
end
