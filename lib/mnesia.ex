:mnesia.create_schema([node()])
:mnesia.start()
:mnesia.create_table(Experiments, [attributes: [:id, :name, :sample]])
