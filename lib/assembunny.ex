defmodule Assembunny do
  alias Registers
    
    #@x1  %{0 => {:cpy, 3, :a},
    #1 => {:inc, :a},
    #2 => {:inc, :b},
    #3 => {:dec, :a},
    #4 => {:jnz, :a, -2},
    #5 => {:dec, :a}}

    #@x2  %{0 => {:cpy, 3, :a},
    #1 => {:inc, :a},
    #2 => {:inc, :b},
    #3 => {:dec, :a},
    #4 => {:jnz, 1, 2},
    #5 => {:dec, :a},
    #6 => {:dec, :b},
    #7 => {:inc, :a}}

  def part_one, do: run(c: 0)
  def part_two, do: run(c: 1)
  defp run(initialize_register) do
    instructions = input()
    {:ok, registers} = Registers.start_link initialize_register
    do_run(registers, 0, instructions) 
  end
  defp do_run(registers, pc, instructions) do
      case (pc >= (length Map.keys(instructions))) do
        false ->
          offset = Registers.execute(registers, instructions[pc])
          address = pc + offset
          do_run(registers, address, instructions)
        true ->
          IO.puts "****registers: #{inspect Registers.get registers} ****"
    end
  end
  defp input do
    "./input.txt"
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
