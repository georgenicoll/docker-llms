# docker-llms

Does the following on the local docker:

- Creates a `llms` docker network
- Starts an `ollama` container attached to the `llms` network
- Starts an `open-webui` container attached to the `llms` network, pointing to the `ollama` container, exposed on http port 3000
- Starts a `watchtower` container to monitor and update the other containers when later images are released.

Requires opentofu and docker to be installed.


```bash
tofu init
tofu plan
tofu apply
# ...
tofu destroy
```

Why not just use docker compose or similar?...   ¯\\_(ツ)_/¯ wanted to do it with opentofu.
