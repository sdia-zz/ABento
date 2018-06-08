use Amnesia

defdatabase Database do
  # , type: :ordered_set
  deftable Experiment, [
    :name,
    :sampling,
    :description,
    :created_date,
    :updated_date,
    :start_date,
    :end_date,
    :variants
  ] do
    @type t :: %Experiment{
            name: String.t(),
            sampling: float,
            description: String.t(),
            created_date: DateTime,
            updated_date: DateTime,
            start_date: DateTime,
            end_date: DateTime,
            variants:
              list(%{
                name: String.t(),
                allocation: number,
                is_control: boolean,
                description: String.t(),
                payload: String.t()
              })
          }
    def experiment(self) do
      Experiment.read(self.name)
    end

    def experiment!(self) do
      Experiment.read!(self.name)
    end
  end

  deftable Exclusion, [:experiment_source, :experiment_target, :exclusion_date],
    index: [:experiment_target] do
    @type t :: %Exclusion{
            experiment_source: String.t(),
            experiment_target: String.t(),
            exclusion_date: DateTime
          }

    def exclusion(self) do
      Exclusion.read(self.experiment_source)
    end

    def exclusion!(self) do
      Exclusion.read!(self.experiment_source)
    end
  end

  deftable Allocation, [:user_hash, :user_id, :experiment, :variant, :allocation_date],
    index: [:user_id, :experiment] do
    @type t :: %Allocation{
            user_hash: String.t(),
            user_id: String.t(),
            experiment: String.t(),
            variant: String.t(),
            allocation_date: DateTime
          }

    def allocation(self) do
      Allocation.read(self.user_hash)
    end

    def allocation!(self) do
      Allocation.read!(self.user_hash)
    end
  end

##  deftable Action, [:user_hash, :user_id, :experiment, :action_date],
##    index: [:user_id, :experiment] do
##    @type t :: %Action{
##            user_hash: String.t(),
##            user_id: String.t(),
##            experiment: String.t(),
##            action_date: DateTime
##          }
##
##    def action(self) do
##      Action.read(self.user_hash)
##    end
##
##    def action!(self) do
##      Action.read!(self.user_hash)
##    end
##  end
##
##  deftable Impression, [:user_hash, :user_id, :experiment, :impression_date],
##    index: [:user_id, :experiment] do
##    @type t :: %Impression{
##            user_hash: String.t(),
##            user_id: String.t(),
##            experiment: String.t(),
##            impression_date: DateTime
##          }
##
##    def impression(self) do
##      Impression.read(self.user_hash)
##    end
##
##    def impression!(self) do
##      Impression.read!(self.user_hash)
##    end
##  end
end

defmodule Abento.DB do
  use Amnesia
  use Database

  def populate do
    Amnesia.transaction do
      variants = [
        %{
          "name" => "bucket_a_25",
          "allocation" => 25,
          "is_control" => true,
          "description" => "bucket A",
          "payload" => "Nada"
        },
        %{
          "name" => "bucket_b_25",
          "allocation" => 25,
          "is_control" => false,
          "description" => "bucket B",
          "payload" => "Nada"
        },
        %{
          "name" => "bucket_c_50",
          "allocation" => 50,
          "is_control" => false,
          "description" => "bucket C",
          "payload" => "Nada"
        }
      ]

      %Experiment{
        name: "experiment_00",
        sampling: 5,
        description: "Experiment 00",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()

      %Experiment{
        name: "experiment_01",
        sampling: 5,
        description: "Experiment 01",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()

      %Experiment{
        name: "experiment_02",
        sampling: 5,
        description: "Experiment 02",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()

      %Experiment{
        name: "experiment_03",
        sampling: 5,
        description: "Experiment 03",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()

      %Experiment{
        name: "experiment_04",
        sampling: 5,
        description: "Experiment 04",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()

      %Experiment{
        name: "experiment_05",
        sampling: 5,
        description: "Experiment 05",
        created_date: DateTime.utc_now(),
        updated_date: DateTime.utc_now(),
        start_date: DateTime.utc_now(),
        end_date: DateTime.utc_now(),
        variants: variants
      }
      |> Experiment.write()
    end
  end
end
