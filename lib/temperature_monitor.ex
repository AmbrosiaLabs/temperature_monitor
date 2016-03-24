defmodule TemperatureMonitor do
  use Application

  def start(_type, _args) do
    {:ok, _pid} = TemperatureMonitor.Supervisor.start_link(Application.get_env(:temperature_monitor, :filelist)) |> IO.inspect
  end
end
