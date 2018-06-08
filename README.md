# Abento

A/B testing app: in-memory, fast and lightweight.


## Installation

Local build


``` bash
docker build -t sdia/abento:latest  .
docker run -d -p 8000:8000 sdia/abento:latest
docker push sdia/abento:latest
```


assignments
impressions
actions



```bash

kubectl exec -it some-pod -- /bin/bash
bin/myapp remote_console
```







_build/prod/rel/abento/bin/abento remote_console

# Amnesia.Schema.create
# Amnesia.start
# Database.create(disk: [node])
# Database.wait

[
  error: {:bad_type, Database, :disc_copies, :"myapp@10.1.0.88"},
  error: {:bad_type, Database.Impression, :disc_copies, :"myapp@10.1.0.88"},
  error: {:bad_type, Database.Action, :disc_copies, :"myapp@10.1.0.88"},
  error: {:bad_type, Database.Assignment, :disc_copies, :"myapp@10.1.0.88"},
  error: {:bad_type, Database.Exclusion, :disc_copies, :"myapp@10.1.0.88"},
  error: {:bad_type, Database.Experiment, :disc_copies, :"myapp@10.1.0.88"}
]
