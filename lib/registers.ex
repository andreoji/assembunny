defmodule Registers do

  def start_link initialize_register do
    Agent.start_link fn -> 
      state = %{a: 0, b: 0, c: 0, d: 0}
      %{state | c: initialize_register[:c]} 
    end
  end
  def execute(pid, op) do
    case op do
      {:inc, register} ->
        :ok = Agent.update pid, &Map.put(&1, register, (fn -> Map.get &1, register end).() + 1)
        1
      {:dec, register} ->
        :ok = Agent.update pid, &Map.put(&1, register, (fn -> Map.get &1, register end).() - 1)
        1
      {:cpy, x, y} when is_integer x ->
        :ok = Agent.update pid, &Map.put(&1, y, x)
        1
      {:cpy, x, y} when is_atom x ->
        :ok = Agent.update pid, &Map.put(&1, y, (fn -> Map.get &1, x end).())
        1
      {:jnz, x, y} when is_atom x ->
          if (Agent.get pid, &Map.get(&1, x) != 0), do: y, else: 1
      {:jnz, x, y} when is_integer x ->
        if x != 0, do: y, else: 1
      _ -> raise "Unrecognized Opcode"
    end
  end
  def get(pid), do: Agent.get pid, &(&1) 
end
