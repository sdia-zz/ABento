defmodule Abento.Router do
  use Plug.Router
  require Logger

  use Amnesia
  use Database

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  get "/" do
    response = %{
      app: "the magic real",
      current_node: :erlang.node(),
      connected_nodes: :erlang.nodes()
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Poison.encode!(response))
  end

  get "/api/experiments/" do
    resp = Abento.Experiment.get_experiments()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp)
  end

  get "/api/experiments/:name" do
    resp = Abento.Experiment.get_experiment(name)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp)
  end

  # post "/api/variants/experiments/:experiment_name/user/:user_id" do
  get "/api/variants/experiments/:experiment_name/user/:user_id" do
    Logger.info(fn -> "#{experiment_name}" end)
    Logger.info(fn -> "#{user_id}" end)

    resp = Abento.Allocation.get_variant(experiment_name, user_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp)
  end

  post "/api/experiments" do
    {status, body} = Abento.Experiment.create_experiment(conn.body_params)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  match(_, do: send_resp(conn, 404, "Not found :-)!"))
end
