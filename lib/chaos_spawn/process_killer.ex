defmodule ChaosSpawn.ProcessKiller do
  require Logger
  alias ChaosSpawn.ProcessWatcher

  def start_link(interval, probability, process_watcher) do
    spawn(fn -> kill_loop(interval, probability, process_watcher) end)
  end

  def kill(pid) do
    Logger.debug("Killing pid #{inspect pid}")
    Process.exit(pid, :kill)
  end

  defp kill_loop(interval, probability, process_watcher) do
    Logger.debug("Sleeping for #{interval} ms")
    :timer.sleep(interval)
    Logger.debug("Deciding if a process should be killed #{probability}")
    if :random.uniform <= probability do
       Logger.debug("Finding a process to kill")
       pid = ProcessWatcher.get_random_pid(process_watcher)
       kill(pid)
    end
    kill_loop(interval, probability, process_watcher)
  end
end
