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

  deftable Assignment, [:user_hash, :user_id, :experiment, :variant, :assignment_date],
    index: [:user_id, :experiment] do
    @type t :: %Assignment{
            user_hash: String.t(),
            user_id: String.t(),
            experiment: String.t(),
            variant: String.t(),
            assignment_date: DateTime
          }

    def assignment(self) do
      Assignment.read(self.user_hash)
    end

    def assignment!(self) do
      Assignment.read!(self.user_hash)
    end
  end

  deftable Exclusion, [:experiment_source, :experiment_target, :exclusion_date],
    index: [:experiment_source, :experiment_target] do
    @type t :: %Exclusion{
        experiment_source: String.t(),
        experiment_target: String.t(),
        exclusion_date: DateTime
      }
    end

    def exclusion(self) do
      Exclusion.read(self.experiment_source)
    end

    def exclusion!(self) do
      Exclusion.read!(self.experiment_source)
    end

end
