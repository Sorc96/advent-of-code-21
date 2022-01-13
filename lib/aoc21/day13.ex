defmodule Aoc21.Day13 do
  use InputLoader

  def run_a do
    {dots, folds} = parse_input()

    folds
    |> hd()
    |> fold(dots)
    |> Enum.count()
  end

  def run_b do
    {dots, folds} = parse_input()

    folds
    |> Enum.reduce(dots, &fold/2)
    |> build_paper()
  end

  defp parse_input do
    input = input_data()
    {parse_dots(input), parse_folds(input)}
  end

  defp parse_dots(lines) do
    lines
    |> Enum.filter(&Regex.match?(~r/^\d/, &1))
    |> Enum.map(&parse_dot/1)
  end

  defp parse_dot(line) do
    [_, x, y] = Regex.run(~r/(\d+),(\d+)/, line)
    {String.to_integer(x), String.to_integer(y)}
  end

  defp parse_folds(lines) do
    lines
    |> Enum.filter(&String.starts_with?(&1, "fold"))
    |> Enum.map(&parse_fold/1)
  end

  defp parse_fold(line) do
    [_, axis, index] = Regex.run(~r/([x|y])=(\d+)/, line)
    {axis, String.to_integer(index)}
  end

  defp fold({"x", index}, dots) do
    dots
    |> Enum.map(fn {x, y} -> {invert(x, index), y} end)
    |> Enum.uniq()
  end

  defp fold({"y", index}, dots) do
    dots
    |> Enum.map(fn {x, y} -> {x, invert(y, index)} end)
    |> Enum.uniq()
  end

  defp invert(index, axis) do
    if index > axis do
      2 * axis - index
    else
      index
    end
  end

  defp build_paper(dots) do
    for y <- 0..height(dots) do
      for x <- 0..width(dots), into: "" do
        if {x, y} in dots, do: "#", else: " "
      end
    end
  end

  defp width(dots) do
    dots
    |> Enum.map(&elem(&1, 0))
    |> Enum.max()
  end

  defp height(dots) do
    dots
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end
end
