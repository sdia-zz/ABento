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
      current_node: :erlang.node,
      connected_nodes: :erlang.nodes
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Poison.encode!(response))
  end

  get "/api/experiments/:id" do
    send_resp(conn, 200, get_experiment(id))
  end

  get "/api/experiments" do
    send_resp(conn, 200, get_experiments())
  end

  post "/api/assignments/:experiment" do
    # {status, body} = create_assignment(conn.body_params, experiment)

    body = %{"message" => "NOT_IMPLMENTED_ERROR", "experiment" => experiment} |> Poison.encode!()
    status = 200
    send_resp(conn, status, body)
  end

  post "/api/experiments" do
    {status, body} = create_experiment(conn.body_params)
    send_resp(conn, status, body)
  end

  match(_, do: send_resp(conn, 404, "Not found :-)!"))

  defp get_experiments() do
    Amnesia.transaction do
      selection = Experiment.where(true)
      selection |> Amnesia.Selection.values() |> Poison.encode!()
    end
  end

  defp get_experiment(id) do
    Poison.encode!(%{"experiment_id" => id, "label" => "button_color"})
  end

  defp create_experiment(p) do
    body =
      Amnesia.transaction do
        %Experiment{
          name: p["name"],
          sampling: p["sampling"],
          description: p["description"],
          created_date: DateTime.utc_now(),
          updated_date: DateTime.utc_now(),
          start_date: p["start_date"],
          end_date: p["end_date"],
          variants: p["variants"]
        }
        |> Experiment.write()

        q = Experiment.where(name == p["name"])
        q |> Amnesia.Selection.values() |> Poison.encode!()
      end

    {200, body}
  end
end
