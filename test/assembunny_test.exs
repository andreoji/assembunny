defmodule AssembunnyTest do
  use ExUnit.Case
  alias Assembunny

  test "part_one" do
    assert %Registers{a: -1, b: 4, c: 0, d: 0} == Assembunny.part_one "./data/input_1.txt"
    assert %Registers{a: 4, b: 0, c: 0, d: 0} == Assembunny.part_one "./data/input_2.txt"
  end
end
