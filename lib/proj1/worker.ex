defmodule Proj1.Worker do
  use GenServer, restart: :transient
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end


  def init(:no_args) do
    Process.send_after(self(), :check_num, 0)
    { :ok, nil }
  end

  def handle_info(:check_num, _) do
    Proj1.Generator.get_sequence
    |> add_result
  end

  def add_result(nil) do
    Proj1.Collector.finish()
    {:stop, :normal, nil}
  end

  def add_result(n) do
    Proj1.Collector.add_result(n, vampire_factors(n))
    send(self(), :check_num)
    { :noreply, nil }
  end

  def factor_pairs(n) do
    first = trunc(n / :math.pow(10, div(char_len(n), 2)))
    last  = :math.sqrt(n) |> round
    for i <- first .. last, rem(n, i) == 0, do: {i, div(n, i)}
  end

  def vampire_factors(n) do
    if rem(char_len(n), 2) == 1 do
      []
    else
      half = div(length(to_char_list(n)), 2)
      sorted = Enum.sort(String.codepoints("#{n}"))
      Enum.filter(factor_pairs(n), fn {a, b} ->
        char_len(a) == half && char_len(b) == half &&
          Enum.count([a, b], fn x -> rem(x, 10) == 0 end) != 2 &&
          Enum.sort(String.codepoints("#{a}#{b}")) == sorted
      end)
    end
  end

  defp char_len(n), do: length(to_char_list(n))
end
