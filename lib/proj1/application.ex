defmodule Proj1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    System.argv() |> parse_args |> process
  end


  def parse_args(args) do
    parse =
      OptionParser.parse(args,
        strict: [n: :integer, k: :integer]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [n, k], _} ->
        {String.to_integer(n), String.to_integer(k)}

      _ ->
        :help
    end
  end

  def process({n, k}) do
    #IO.puts("#{n} , #{k}")
    # List all child processes to be supervised
    children = [
      {Proj1.Generator,{n,k} },
       Proj1.Wsupervisor,
      {Proj1.Collector,2}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Proj1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
