FROM elixir:latest
COPY . /src
WORKDIR /src
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix do deps.get, compile
RUN MIX_ENV=prod mix release --env=prod
EXPOSE 8000
ENTRYPOINT _build/prod/rel/abento/bin/abento foreground
