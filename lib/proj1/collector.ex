defmodule Proj1.Collector do
  use GenServer

  @me CollectResults



  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def finish() do
    GenServer.cast(@me, :end)
  end

  def add_result(start, valid) do
    GenServer.cast(@me, { :add_result, start, valid })
  end



  def init(worker_count) do
    Process.send_after(self(), :start, 0)
    { :ok, worker_count }
  end

  def handle_info(:start, worker_count) do
    1..worker_count
    |> Enum.each(fn _ -> Proj1.Wsupervisor.start_worker() end)
    { :noreply, worker_count }
  end

  def handle_cast(:end, _worker_count = 1) do
    System.halt(0)
  end

  def handle_cast(:end, worker_count) do
    { :noreply, worker_count - 1 }
  end

  def handle_cast({:add_result, n, fact}, worker_count) do
    if length(fact) != 0 do
      #IO.inspect(n)
      #IO.inspect(fact)
      vf1 = Enum.map(fact, fn {x,y} -> [Integer.to_string(x), Integer.to_string(y)]
      end)
      vf2 = List.flatten(vf1)
      vf3 = Enum.reduce(vf2,"", fn(x, acc) ->  x <>" " <>acc end)
      vf4 = String.trim(vf3)
      #Enum.reduce(vf1, fn(x, acc) -> x <> " " <> acc end)
      IO.puts "#{n}\t#{ vf4}"
    end
    { :noreply, worker_count }
  end

end
