defmodule TemperatureMonitor.Supervisor do
  use Supervisor

  def start_link(filelist) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [filelist]) |> IO.inspect
    start_workers(sup, filelist)
    result
  end

  def start_workers(sup, filelist) do
    {:ok, stash} = Supervisor.start_child(sup, worker(TemperatureMonitor.Stash, [filelist])) |> IO.inspect
    Supervisor.start_child(sup, supervisor(TemperatureMonitor.SubSupervisor, [stash])) |> IO.inspect
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
