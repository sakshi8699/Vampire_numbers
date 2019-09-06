defmodule Proj1.Generator do
  use GenServer
  require Logger
  @me Sd

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @me)
  end

  def get_sequence() do
    GenServer.call(@me, :get_sequence)
  end


  @spec init(any()) :: {:ok, any()}
  def init(args) do
    {:ok,args}
  end

  def handle_call(:get_sequence, _from, {a,b}) do
    if a>b do
      { :reply, nil, {a,b} }
    else
      { :reply, a, {a+1,b} }
    end
  end

end
