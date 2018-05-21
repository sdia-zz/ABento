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
    send_resp(conn, 200, "Abento api")
  end

  get "/api/experiments/:id" do
    send_resp(conn, 200, get_experiment(id))
  end

  get "/api/experiments" do
    send_resp(conn, 200, get_experiments())
  end

  post "/api/experiments" do
    ## IO.puts("Routing to create_experiment...")
    ## {status, body} =
    ##   case conn.body_params do
    ##     %Experiment -> {200, create_experiment(conn.body_params)}
    ##     _ -> {400, "Bad request"}
    ##   end

    {status, body} = create_experiment(conn.body_params)
    send_resp(conn, status, body)
  end

  match(_, do: send_resp(conn, 404, "Not found :-)!"))

  defp get_experiments() do
    ##    data = [
    ##      %{"experiment_id" => 1, "label" => "button_color"},
    ##      %{"experiment_id" => 2, "label" => "home page update"},
    ##      %{"experiment_id" => 3, "label" => "backend testing"},
    ##      %{"experiment_id" => 4, "label" => "a/a testing"},
    ##      %{"experiment_id" => 5, "label" => "new layout style"}
    ##    ]
    ##
    ##    Poison.encode!(data)
    Amnesia.transaction do
      selection = Experiment.where true
      selection |> Amnesia.Selection.values |> Poison.encode!
    end

  end

  defp get_experiment(id) do
    Poison.encode!(%{"experiment_id" => id, "label" => "button_color"})
  end

  defp create_experiment(p) do
    ##  Poison.encode!(%{"experiment_id" => 12, "label" => xp_label})

    body = Amnesia.transaction do
       %Experiment{name: p["name"],
                   sampling: p["sampling"],
                   description: p["description"],
                   created_date: DateTime.utc_now,
                   updated_date: DateTime.utc_now,
                   start_date: p["start_date"],
                   end_date: p["end_date"],
                   variants: p["variants"]
                 }


                   |> Experiment.write


     (Experiment.where name == p["name"])
             |> Amnesia.Selection.values
             |> Poison.encode!
    end
    {200, body}
  end
end
