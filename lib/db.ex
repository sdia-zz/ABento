use Amnesia

defdatabase Database do

  deftable Experiment, [ :name,
                         :sampling,
                         :description,
                         :created_date,
                         :updated_date,
                         :start_date,
                         :end_date,
                         :variants]

            # , type: :ordered_set
            do
    @type t :: %Experiment{name: String.t,
                           sampling: float,
                           description: String.t,
                           created_date: DateTime,
                           updated_date: DateTime,
                           start_date: DateTime,
                           end_date: DateTime,
                           variants: list(%{name: String.t,
                                            allocation: number,
                                            is_control: boolean,
                                            description: String.t,
                                            payload: String.t})}
    def experiment(self) do
      Experiment.read(self.name)
    end

    def experiment!(self) do
      Experiment.read!(self.name)
    end
  end


  deftable Assignment, [:user_hash, :user_id, :experiment, :variant, :assigned_at], index: [:user_id, :experiment] do
    @type t :: %Assignment{user_hash: String.t,
                           user_id: String.t,
                           experiment: String.t,
                           variant: String.t,
                           assigned_at: DateTime}



    def assignment(self) do
      Assignment.read(self.user_hash)
    end

    def assignment!(self) do
      Assignment.read!(self.user_hash)
    end
  end

################################################################################
  deftable User

  deftable Message, [:user_id, :content], type: :bag do
      @type t :: %Message{user_id: integer, content: String.t}

    def user(self) do
      User.read(self.user_id)
    end

    def user!(self) do
      User.read!(self.user_id)
    end
  end

  deftable User, [{ :id, autoincrement }, :name, :email], type: :ordered_set, index: [:email] do
        @type t :: %User{id: non_neg_integer, name: String.t, email: String.t}

    def add_message(self, content) do
      %Message{user_id: self.id, content: content} |> Message.write
    end

    def add_message!(self, content) do
      %Message{user_id: self.id, content: content} |> Message.write!
    end

    def messages(self) do
      Message.read(self.id)
    end

    def messages!(self) do
      Message.read!(self.id)
    end
  end

end
