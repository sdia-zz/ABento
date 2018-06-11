defmodule Fixtures do

  def run() do
    IO.puts("#{DateTime.utc_now}")
    DB.create_tables()
    populate_experiments()
    populate_assignments()
    IO.puts("#{DateTime.utc_now}")
    # {:ok, "Done"}
  end

  def populate_experiments() do
    variant_0 = %DB.Variant{name: "variant_0", allocation: 20, is_control: true}
    variant_1 = %DB.Variant{name: "variant_1", allocation: 20, is_control: false}
    variant_2 = %DB.Variant{name: "variant_2", allocation: 20, is_control: false}
    variant_3 = %DB.Variant{name: "variant_3", allocation: 20, is_control: false}
    variant_4 = %DB.Variant{name: "variant_4", allocation: 20, is_control: false}

    variants=[variant_0, variant_1, variant_2, variant_3, variant_4]

    DB.put_experiment(%DB.Experiment{name: "experiment_00", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_01", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_02", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_03", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_04", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_05", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_06", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_07", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_08", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})
    DB.put_experiment(%DB.Experiment{name: "experiment_09", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now})

  end

  def populate_assignments() do
    variants = [%DB.Variant{name: "variant_4", allocation: 20, is_control: false}]
    exp = %DB.Experiment{name: "experiment_00", sampling: 25, variants: variants, start_date: DateTime.utc_now, end_date: DateTime.utc_now}

    1..100_000
    |> Stream.map(&(to_string(&1)))
    |> Stream.map(&(DB.put_assignment(&1, exp)))
    |> Enum.reduce(0, fn(_x, acc) -> 1 + acc end)

  end

end
