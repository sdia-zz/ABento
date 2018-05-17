defmodule Abento.Router do
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Abento api")
  end

  get "/api/experiments/:id" do
    send_resp(conn, 200, get_experiment(id))
  end

  get "/api/experiments" do
    send_resp(conn, 200, get_experiments())
  end

  post "/api/experiments" do
    {status, body} =
      case conn.body_params do
        %{"experiment_label" => experiment_label} -> {200, create_experiment(experiment_label)}
        _ -> {400, "Bad request"}
      end

    send_resp(conn, status, body)
  end

  match(_, do: send_resp(conn, 404, "Not found :-)!"))

  defp get_experiments() do
    data = [
      %{"experiment_id" => 1, "label" => "button_color"},
      %{"experiment_id" => 2, "label" => "home page update"},
      %{"experiment_id" => 3, "label" => "backend testing"},
      %{"experiment_id" => 4, "label" => "a/a testing"},
      %{"experiment_id" => 5, "label" => "new layout style"}
    ]

    Poison.encode!(data)
  end

  defp get_experiment(id) do
    Poison.encode!(%{"experiment_id" => id, "label" => "button_color"})
  end

  defp create_experiment(xp_label) do
    Poison.encode!(%{"experiment_id" => 12, "label" => xp_label})
  end
end
