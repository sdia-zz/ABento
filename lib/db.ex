defmodule DB do
  @type key :: String.t()

  defmodule Variant do
    @type t :: %Variant{
            name: String.t(),
            allocation: number,
            is_control: boolean,
            description: String.t(),
            payload: String.t()
          }

    @enforce_keys [:name, :allocation, :is_control]
    @other_keys [:description, :payload]

    defstruct @enforce_keys ++ @other_keys
  end

  defmodule Experiment do
    # @TODO: add exclusion field
    @type t :: %Experiment{
            name: String.t(),
            sampling: float,
            variants: list(Variant.t()),
            start_date: DateTime,
            end_date: DateTime,
            description: String.t(),
            tags: list(String.t()),
            created_date: DateTime,
            updated_date: DateTime
          }

    @enforce_keys [:name, :sampling, :variants, :start_date, :end_date]
    @other_keys [:description, :tags, :created_date, :updated_date]

    defstruct @enforce_keys ++ @other_keys
  end

  defmodule Exclusion do
    @type t :: %Exclusion{
            experiment_name: String.t(),
            excluded_experiments: MapSet.t(String.t())
          }
    @enforce_keys [:experiment_name, :excluded_experiments]
    @other_keys []

    defstruct @enforce_keys ++ @other_keys
  end

  defmodule Assignment do
    @type t :: %Assignment{
            hash_id: String.t(),
            user_id: String.t(),
            experiment_name: String.t(),
            variant: String.t(),
            assign_date: DateTime
          }

    @enforce_keys [:hash_id, :user_id, :experiment_name, :variant, :assign_date]
    @other_keys []

    defstruct @enforce_keys ++ @other_keys
  end

  def create_tables do
    :lbm_kv.create(Experiment)
    :lbm_kv.create(Exclusion)
    :lbm_kv.create(Assignment)
  end

  def get_hash(s) do
    :crypto.hash(:md5, s) |> Base.encode16() |> String.downcase()
  end

  ## EXPERIMENT
  @spec put_experiment(Experiment.t()) :: {:ok, Experiment.t()} | {:error, any()}
  def put_experiment(exp) do
    case :lbm_kv.put(Experiment, exp.name, exp) do
      {:ok, [{_, exp}]} -> {:ok, exp}
      resp -> {:error, resp}      
    end

    # @TODO: manage exclusion as well... or NOT: exclusion is not XP attribute!!
  end

  @spec get_experiment(key()) :: {:ok, Experiment.t} | {:error, any()}
  def get_experiment(exp_name) do
    case :lbm_kv.get(Experiment, exp_name) do
      {:ok, [{_, exp}]} -> {:ok, exp}
      resp -> {:error, resp}
    end
  end


  @spec get_experiments() :: {:ok, [Experiment.t()]} | {:error, any()}
  def get_experiments() do
    ## :lbm_kv.get(Experiment, exp_name)

    fun = fn ->
      :mnesia.match_object(
        DB.Experiment,
        :mnesia.table_info(DB.Experiment, :wild_pattern),
        :read)
    end

    case :mnesia.transaction(fun) do
      {:atomic, exps} -> {:ok, exps}
      resp -> {:error, resp}
    end
  end

  @spec del_experiment(key() | [key()]) :: {:ok, [{key(), Experiment.t()}]} | {:error, any()}
  def del_experiment(key_or_keys) do
    :lbm_kv.del(Experiment, key_or_keys)

    # @TODO: remove exclusions as well
  end

  ## EXCLUSION
  @spec put_exclusion(Experiment.t(), Experiment.t()) ::
          {:ok, [{key(), Exclusion.t()}]} | {:error, any()}
  def put_exclusion(exp_a, exp_b) do
    ex_AB = do_generate_exclusion(exp_a, exp_b)
    ex_BA = do_generate_exclusion(exp_b, exp_a)
    :lbm_kv.put(Exclusion, [{ex_AB.experiment_name, ex_AB}, {ex_BA.experiment_name, ex_BA}])
  end

  @spec do_generate_exclusion(Experiment.t(), Experiment.t()) :: Exclusion.t() | {:error, any()}
  defp do_generate_exclusion(exp_a, exp_b) do
    new_exclusions =
      case get_exclusion(exp_a.name) do
        {:ok, [_, excl]} -> excl.excluded_experiments
        _ -> MapSet.new()
      end
      |> MapSet.put(exp_b.name)

    %Exclusion{
      experiment_name: exp_a.name,
      excluded_experiments: new_exclusions
    }
  end

  @spec get_exclusion(key()) :: {:ok, [{key(), Exclusion.t()}]} | {:error, any()}
  def get_exclusion(exp_name) do
    :lbm_kv.get(Exclusion, exp_name)
  end

  @spec del_exclusion(Experiment.t(), Experiment.t()) :: {:ok, {key(), key()}} | {:error, any()}
  def del_exclusion(exp_a, exp_b) do
    ex_AB = do_remove_exclusion(exp_a, exp_b)
    ex_BA = do_remove_exclusion(exp_b, exp_a)
    :lbm_kv.put(Exclusion, [{ex_AB.experiment_name, ex_AB}, {ex_BA.experiment_name, ex_BA}])
  end

  @spec do_remove_exclusion(Experiment.t(), Experiment.t()) :: Exclusion.t() | {:error, any()}
  def do_remove_exclusion(exp_a, exp_b) do
    new_exclusions =
      case get_exclusion(exp_a.name) do
        {:ok, [_, excl]} -> excl.excluded_experiments
        _ -> MapSet.new()
      end
      |> MapSet.delete(exp_b.name)

    %Exclusion{
      experiment_name: exp_a.name,
      excluded_experiments: new_exclusions
    }
  end

  ## ALLOCATION
  @spec put_assignment(String.t(), Experiment.t()) ::
          {:ok, [{key(), Assignment.t()}]} | {:error, any()}
  def put_assignment(user_id, exp) do
    ## @type t :: %Assignment{
    ##   hash_id: String.t,
    ##   user_id: String.t,
    ##   experiment_name: String.t,
    ##   variant: String.t,
    ##   assign_date: DateTime
    ## }

    # @TODO:
    alloc_variant = "variant_name"
    ## alloc_type = "NEW_ASSIGNMENT"

    hash_id = "#{user_id}#{exp.name}" |> get_hash

    alloc = %Assignment{
      hash_id: hash_id,
      user_id: user_id,
      experiment_name: exp.name,
      variant: alloc_variant,
      assign_date: DateTime.utc_now()
    }

    :lbm_kv.put(Assignment, hash_id, alloc)
  end

  @spec get_assignment(key(), Experiment.t()) ::
          {:ok, [{key(), Assignment.t()}]} | {:error, any()}
  def get_assignment(user_id, exp) do
    hash_id = "#{user_id}#{exp.name}" |> get_hash
    :lbm_kv.get(Assignment, hash_id)
  end

  @spec del_assignment(key() | [key()]) :: {:ok, [{key(), Assignment.t()}]} | {:error, any()}
  def del_assignment(key_or_keys) do
    :lbm_kv.del(Assignment, key_or_keys)
  end
end
