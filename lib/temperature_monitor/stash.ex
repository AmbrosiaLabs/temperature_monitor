defmodule TemperatureMonitor.Stash do
  use GenServer

  def start_link(filelist) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, filelist)
  end

  def save_value(pid, value) do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  def handle_call(:get_value, _from, filelist) do
    {:reply, filelist, filelist}
  end

  def handle_cast({:save_value, value}, _filelist) do
    {:noreply, value}
  end
end
