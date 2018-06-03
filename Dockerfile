FROM elixir:latest
COPY . /src
WORKDIR /src




RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix do deps.get, compile


# RUN mix release.init
RUN MIX_ENV=prod mix release --env=prod





# RUN mix amnesia.drop   --database Database
RUN mix amnesia.create --database Database --disk


EXPOSE 8000
# ENTRYPOINT mix run --no-halt

ENTRYPOINT   _build/prod/rel/abento/bin/abento foreground
