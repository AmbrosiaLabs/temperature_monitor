defmodule TemperatureMonitor.Monitor do

  def start(base_path) do
    add_path(base_path)
    ExFSWatch.Supervisor.start_child(__MODULE__)
  end

  def add_path(base_path) do
    TemperatureMonitor.TemperatureHandler.monitor_path(base_path)
  end

  def __dirs__ do
    TemperatureMonitor.TemperatureHandler.get_monitored_paths
  end

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(filepath, events) do
    IO.inspect {filepath, events}

    TemperatureMonitor.TemperatureHandler.sample(filepath) |> IO.inspect
  end
end
