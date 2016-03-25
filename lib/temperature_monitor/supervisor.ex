defmodule TemperatureMonitor.Supervisor do
  use Supervisor

  def start_link(filelist, base_path) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [filelist])
    start_workers(sup, filelist, base_path)
    result
  end

  def start_workers(sup, filelist, base_path) do
    {:ok, stash} = Supervisor.start_child(sup, worker(TemperatureMonitor.Stash, [filelist]))
    Supervisor.start_child(sup, supervisor(TemperatureMonitor.SubSupervisor, [stash]))
    TemperatureMonitor.Monitor.start(base_path)
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
