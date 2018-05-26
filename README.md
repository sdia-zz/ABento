# Abento

A/B testing app: in-memory, fast and lightweight.



## Installation

Local build
``` bash
docker build -t abento  .
docker run -d -p 8000:8000 abento
```

Push to registry
```bash
docker tag xxxx sdia/abento:test
docker push sdia/abento:test
```
