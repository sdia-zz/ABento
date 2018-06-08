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
    resp = get_experiments()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp)
  end

  get "/api/experiments/:name" do
    send_resp(conn, 200, get_experiment(name))
  end

  # post "/api/variants/experiments/:experiment_name/user/:user_id" do
  get "/api/variants/experiments/:experiment_name/user/:user_id" do
    Logger.info(fn -> "#{experiment_name}" end)
    Logger.info(fn -> "#{user_id}" end)

    resp = get_variant(experiment_name, user_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp)
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

  defp get_experiment(xp_name) do
    Amnesia.transaction do
      # var name matters!
      selection = Experiment.where(name == xp_name)

      selection
      |> Amnesia.Selection.values()
      # @TODO : make sure only one is returned
      |> hd
      |> Poison.encode!()
    end
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

  def get_variant(experiment_name, user_id) do
    variants =
      Amnesia.transaction do
        selection =
          Experiment.where(
            name == experiment_name,
            select: variants
          )

        selection
        |> Amnesia.Selection.values()
        # @TODO : make sure only one is returned
        |> hd

        # |> Poison.encode!()
      end
      |> calculate
      |> Poison.encode!()
  end

  def calculate(variants) do
    ttl =
      variants
      |> Enum.map(& &1["allocation"])
      |> Enum.sum()

    rand = :rand.uniform() * ttl

    decision(variants, rand)
  end

  defp decision(variants, rand, low \\ 0) do
    [h | t] = variants

    alloc = h["allocation"]
    high = alloc + low

    cond do
      low <= rand && rand < high -> h
      true -> decision(t, rand, high)
    end
  end
end
