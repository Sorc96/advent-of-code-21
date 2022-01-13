defmodule Aoc21.Day2 do
  use InputLoader

  def run_a do
    commands()
    |> perform_moves()
    |> multiply_results()
  end

  def run_b do
    commands()
    |> perform_aimed_moves()
    |> multiply_results()
  end

  defp commands do
    input_data()
    |> Enum.map(&parse_command/1)
  end

  defp parse_command(line) do
    [direction, x] = String.split(line, " ")
    {direction, String.to_integer(x)}
  end

  defp perform_moves(moves) do
    Enum.reduce(moves, {0, 0}, &perform_move/2)
  end

  defp perform_move({direction, x}, {horizontal, depth}) do
    case direction do
      "forward" -> {horizontal + x, depth}
      "down" -> {horizontal, depth + x}
      "up" -> {horizontal, depth - x}
    end
  end

  defp perform_aimed_moves(moves) do
    {horizontal, depth, _} = Enum.reduce(moves, {0, 0, 0}, &perform_aimed_move/2)
    {horizontal, depth}
  end

  defp perform_aimed_move({direction, x}, {horizontal, depth, aim}) do
    case direction do
      "forward" -> {horizontal + x, depth + aim * x, aim}
      "down" -> {horizontal, depth, aim + x}
      "up" -> {horizontal, depth, aim - x}
    end
  end

  defp multiply_results({horizontal, depth}), do: horizontal * depth
end
