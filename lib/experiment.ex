defmodule Abento.Experiment do
  use Amnesia
  use Database

  def get_experiments() do
    Amnesia.transaction do
      selection = Experiment.where(true)
      selection |> Amnesia.Selection.values() |> Poison.encode!()
    end
  end

  def get_experiment(xp_name) do
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

  def create_experiment(p) do
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
