FROM elixir:1.20-otp-29-slim

RUN apt-get update -y && \
  apt-get install -y build-essential git inotify-tools && \
  apt-get clean && \
  rm -f /var/lib/apt/lists/*_*

RUN mix local.hex --force && \
  mix local.rebar --force

ENV MIX_ENV=dev

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config/ ./config/

RUN mix deps.get
RUN mix deps.compile

COPY . .

EXPOSE 4000

CMD ["iex",  "-S", "mix", "phx.server"]
