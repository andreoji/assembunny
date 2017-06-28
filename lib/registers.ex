defmodule Registers do

  defstruct [:a, :b, :c, :d]

  def start(initialize_register) do
    Map.merge %Registers{a: 0, b: 0, c: 0, d: 0}, initialize_register
  end

  def execute(registers, op) do
    case op do
      {:inc, register} ->
        {Map.update!(registers, register, &(&1 + 1)), 1}

      {:dec, register} ->
        {Map.update!(registers, register, &(&1 - 1)), 1}

      {:cpy, x, y} when is_integer x ->
        {Map.put(registers, y, x), 1}

      {:cpy, x, y} when is_atom x ->
        {Map.put(registers, y, (fn -> Map.get registers, x end).()), 1}

      {:jnz, x, y} when is_atom x ->
        if (Map.get(registers, x) != 0), do: {registers, y}, else: {registers, 1}

      {:jnz, x, y} when is_integer x ->
        if x != 0, do: {registers, y}, else: {registers, 1}
      _ -> raise "Unrecognized Opcode"
    end
  end
end
