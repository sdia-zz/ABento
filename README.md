# Abento

A/B testing app: in-memory, fast and lightweight.




``` bash
docker build -t sdia/abento:latest  .
docker run -d -p 8000:8000 sdia/abento:latest
docker push sdia/abento:latest
```


```bash
$ kubectl get pods
$ kubectl exec -it some-pod -- /bin/bash
$ _build/prod/rel/abento/bin/abento remote_console
```
