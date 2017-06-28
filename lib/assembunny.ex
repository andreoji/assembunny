defmodule Assembunny do
  alias Registers

  def part_one(file \\ "./data/input.txt"), do:  run(%{c: 0}, file)
  def part_two(file \\ "./data/input.txt"), do:  run(%{c: 1}, file)

  defp run(initialize_register, file) do
    instructions = input(file)
    registers = Registers.start initialize_register
    do_run(registers, 0, instructions) 
  end
  defp do_run(registers, pc, instructions) do
    case (pc >= (length Map.keys(instructions))) do
      false ->
        {registers, offset} = Registers.execute(registers, instructions[pc])
        do_run(registers, (pc + offset), instructions)
      true ->
        registers
    end
  end
  defp input(file) do
    file
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_tokens/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i, line} end)
    |> Enum.into(%{})
  end
  defp parse_tokens(tokens) do
    Enum.map(tokens, fn token ->
      case Integer.parse(token) do
        {i, _} -> i
        :error -> token |> String.to_atom
      end
    end)
  end
end
