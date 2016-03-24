defmodule TemperatureMonitor.Monitor do
  use GenServer

  def start_link(stash_pid) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def init(stash_pid) do
    filelist = TemperatureMonitor.Stash.get_value stash_pid
     {:ok, {filelist, stash_pid}}
  end

  def sample_all do
    GenServer.call(__MODULE__, :sample_all)
  end

  def sample(filename) do
    GenServer.call(__MODULE__, {:sample, filename})
  end

  def add_file(filename) do
    GenServer.cast(__MODULE__, {:add_file, filename})
  end

  def handle_call(:sample_all, _from, {filelist, stash_pid}) do
    temperatures =
      filelist
      |> Enum.map(&read_temperature(&1))

    {:reply, temperatures, {filelist, stash_pid}}
  end

  def handle_call({:sample, filename}, _from, {filelist, stash_pid}) do
    temperature = read_temperature(filename)
    {:reply, temperature, {filelist, stash_pid} }
  end

  def handle_cast({:add_file, filename}, {filelist, stash_pid}) do
    {:noreply, { [filename | filelist], stash_pid } }
  end

  def read_temperature(filename) do
    lines = filename
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Enum.take(2)

    {temperature, _} = parse_temperature(List.first(lines), List.last(lines)) 
    {filename, temperature / 1000 }
  end

  def terminate(_reason, {filelist, stash_pid}) do
    TemperatureMonitor.Stash.save_value stash_pid, filelist
  end

  defp parse_temperature(first_string, second_string) do
    cond do 
      String.ends_with?(first_string, "YES") ->
        String.split(second_string, "=") 
        |> List.last 
        |> Integer.parse 
      true ->
        nil
    end
  end

end
