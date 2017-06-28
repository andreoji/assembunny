defmodule RegistersTest do
  use ExUnit.Case
  alias Registers

  setup do
    registers = Registers.start %{c: 0}
    {:ok, %{registers: registers}}
  end
  test "inc registers", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :a}
    {registers, 1} = Registers.execute registers, {:inc, :b}
    assert %Registers{a: 1, b: 1, c: 0, d: 0} == registers
  end
  test "dec registers", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:dec, :c}
    {registers, 1} = Registers.execute registers, {:dec, :d}
    assert %Registers{a: 0, b: 0, c: -1, d: -1} == registers
  end
  test "cpy integer", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :a}
    {registers, 1} = Registers.execute registers, {:cpy, 41, :a}
    assert %Registers{a: 41, b: 0, c: 0, d: 0} == registers
  end
  test "cpy register name", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :a}
    {registers, 1} = Registers.execute registers, {:cpy, 100, :d}
    {registers, 1} = Registers.execute registers, {:cpy, :d, :a}
    assert %Registers{a: 100, b: 0, c: 0, d: 100} == registers
  end
  test "jnz register name not zero", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :b}
    {registers, 1} = Registers.execute registers, {:inc, :a}
    assert {registers, -5} == Registers.execute registers, {:jnz, :b, -5}
    {registers, 1} = Registers.execute registers, {:cpy, 100, :d}
    {registers, 1} = Registers.execute registers, {:cpy, :d, :a}
    assert %Registers{a: 100, b: 1, c: 0, d: 100} == registers
  end
  test "jnz register name equal zero", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :b}
    {registers, 1} = Registers.execute registers, {:dec, :b}
    {registers, 1} = Registers.execute registers, {:inc, :a}
    assert {registers, 1} == Registers.execute registers, {:jnz, :b, -5}
    {registers, 1} = Registers.execute registers, {:cpy, 100, :d}
    {registers, 1} = Registers.execute registers, {:cpy, :d, :a}
    assert %Registers{a: 100, b: 0, c: 0, d: 100} == registers
  end
  test "jnz integer not zero", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :b}
    {registers, 1} = Registers.execute registers, {:inc, :a}
    assert {registers, 5} == Registers.execute registers, {:jnz, 1, 5}
    {registers, 1} = Registers.execute registers, {:cpy, 100, :d}
    {registers, 1} = Registers.execute registers, {:cpy, :d, :a}
    assert %Registers{a: 100, b: 1, c: 0, d: 100} == registers
  end
  test "jnz integer equals zero", context do
    registers = context.registers
    {registers, 1} = Registers.execute registers, {:inc, :b}
    {registers, 1} = Registers.execute registers, {:inc, :a}
    assert {registers, 1} == Registers.execute registers, {:jnz, 0, 5}
    {registers, 1} = Registers.execute registers, {:cpy, 100, :d}
    {registers, 1} = Registers.execute registers, {:cpy, :d, :a}
    assert %Registers{a: 100, b: 1, c: 0, d: 100} == registers
  end
end
