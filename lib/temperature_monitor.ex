defmodule TemperatureMonitor do
  use Application

  def start(_type, _args) do
    filelist = Application.get_env(:temperature_monitor, :filelist) 
    base_path = Application.get_env(:temperature_monitor, :base_path) 
    {:ok, _pid} = TemperatureMonitor.Supervisor.start_link(filelist, base_path)
  end
end
