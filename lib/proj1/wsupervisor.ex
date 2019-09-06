defmodule Proj1.Wsupervisor do
  use DynamicSupervisor
  require Logger

  @me WorkerSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end


  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker() do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Proj1.Worker)
  end
end
