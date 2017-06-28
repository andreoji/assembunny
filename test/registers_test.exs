defmodule RegistersTest do
  use ExUnit.Case
  alias Registers

  setup do
    {:ok, registers} = Registers.start_link c: 0
    {:ok, %{registers: registers}}
  end
  test "inc registers", context do
    1 = Registers.execute context.registers, {:inc, :a}
    1 = Registers.execute context.registers, {:inc, :b}
    assert %{a: 1, b: 1, c: 0, d: 0} == Registers.get context.registers
  end
  test "dec registers", context do
    1 = Registers.execute context.registers, {:dec, :c}
    1 = Registers.execute context.registers, {:dec, :d}
    assert %{a: 0, b: 0, c: -1, d: -1} == Registers.get context.registers
  end
  test "cpy integer", context do
    1 = Registers.execute context.registers, {:inc, :a}
    1 = Registers.execute context.registers, {:cpy, 41, :a}
    assert %{a: 41, b: 0, c: 0, d: 0} == Registers.get context.registers
  end
  test "cpy register name", context do
    1 = Registers.execute context.registers, {:inc, :a}
    1 = Registers.execute context.registers, {:cpy, 100, :d}
    1 = Registers.execute context.registers, {:cpy, :d, :a}
    assert %{a: 100, b: 0, c: 0, d: 100} == Registers.get context.registers
  end
  test "jnz register name not zero", context do
    1 = Registers.execute context.registers, {:inc, :b}
    1 = Registers.execute context.registers, {:inc, :a}
    assert -5 == Registers.execute context.registers, {:jnz, :b, -5}
    1 = Registers.execute context.registers, {:cpy, 100, :d}
    1 = Registers.execute context.registers, {:cpy, :d, :a}
    assert %{a: 100, b: 1, c: 0, d: 100} == Registers.get context.registers
  end
  test "jnz register name equal zero", context do
    1 = Registers.execute context.registers, {:inc, :b}
    1 = Registers.execute context.registers, {:dec, :b}
    1 = Registers.execute context.registers, {:inc, :a}
    assert 1 == Registers.execute context.registers, {:jnz, :b, -5}
    1 = Registers.execute context.registers, {:cpy, 100, :d}
    1 = Registers.execute context.registers, {:cpy, :d, :a}
    assert %{a: 100, b: 0, c: 0, d: 100} == Registers.get context.registers
  end
  test "jnz integer not zero", context do
    1 = Registers.execute context.registers, {:inc, :b}
    1 = Registers.execute context.registers, {:inc, :a}
    assert 5 == Registers.execute context.registers, {:jnz, 1, 5}
    1 = Registers.execute context.registers, {:cpy, 100, :d}
    1 = Registers.execute context.registers, {:cpy, :d, :a}
    assert %{a: 100, b: 1, c: 0, d: 100} == Registers.get context.registers
  end
  test "jnz integer equals zero", context do
    1 = Registers.execute context.registers, {:inc, :b}
    1 = Registers.execute context.registers, {:inc, :a}
    assert 1 == Registers.execute context.registers, {:jnz, 0, 5}
    1 = Registers.execute context.registers, {:cpy, 100, :d}
    1 = Registers.execute context.registers, {:cpy, :d, :a}
    assert %{a: 100, b: 1, c: 0, d: 100} == Registers.get context.registers
  end
end
