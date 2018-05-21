use Amnesia
use Database


Amnesia.transaction do


  variants = [
    %{"name" => "bucket_a", "allocation" => 25, "is_control" => true,  "description" => "bucket A", "payload" => "Nada"},
    %{"name" => "bucket_b", "allocation" => 25, "is_control" => false, "description" => "bucket B", "payload" => "Nada"},
    %{"name" => "bucket_c", "allocation" => 50, "is_control" => false, "description" => "bucket C", "payload" => "Nada"}]


    %Experiment{name: "experiment_00", sampling: 5, description: "Experiment 00", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write
    %Experiment{name: "experiment_01", sampling: 5, description: "Experiment 01", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write
    %Experiment{name: "experiment_02", sampling: 5, description: "Experiment 02", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write
    %Experiment{name: "experiment_03", sampling: 5, description: "Experiment 03", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write
    %Experiment{name: "experiment_04", sampling: 5, description: "Experiment 04", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write
    %Experiment{name: "experiment_05", sampling: 5, description: "Experiment 05", created_date: DateTime.utc_now, updated_date: DateTime.utc_now, start_date: DateTime.utc_now, end_date: DateTime.utc_now, variants: variants} |> Experiment.write



end



:mnesia.dump_log()
