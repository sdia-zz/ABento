FROM elixir:latest
COPY . /src
WORKDIR /src
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix do deps.get, compile
EXPOSE 8000
ENTRYPOINT mix run --no-halt
