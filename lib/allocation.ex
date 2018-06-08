defmodule Abento.Allocation do
  use Amnesia
  use Database

  def get_variant(experiment_name, user_id) do
    case get_variant_existing(experiment_name, user_id) do
      {:ok, variant} -> variant
      _ -> get_variant_new(experiment_name, user_id)
    end
    |> Poison.encode!()
  end

  def get_variant_existing(experiment_name, user_id) do
    uh = (experiment_name <> user_id) |> Abento.Utils.get_hash()

    variant =
      Amnesia.transaction do
        Allocation.where(user_hash == uh, select: variant)
        |> Amnesia.Selection.values()
      end

    case variant do
      [] -> {:error, "not found"}
      [h | _] -> {:ok, h}
    end
  end

  def get_variant_new(experiment_name, user_id) do
    # @TODO: raise if experiment not found
    # @TODO: move this to experiment module
    variant =
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
      end
      |> calculate

    user_hash = (experiment_name <> user_id) |> Abento.Utils.get_hash()

    Amnesia.transaction do
      %Allocation{
        user_hash: user_hash,
        user_id: user_id,
        experiment: experiment_name,
        variant: variant,
        allocation_date: DateTime.utc_now()
      }
      |> Allocation.write()
    end

    variant
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
      low <= rand && rand < high -> h["name"]
      true -> decision(t, rand, high)
    end
  end
end
