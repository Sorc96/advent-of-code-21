defmodule Aoc21.Day5 do
  use InputLoader

  def run_a do
    lines()
    |> Enum.filter(&horizontal_or_vertical?/1)
    |> generate_board()
    |> count_overlapping()
  end

  def run_b do
    lines()
    |> generate_board()
    |> count_overlapping()
  end

  defp lines do
    input_data()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&parse_point/1)
    |> List.to_tuple()
  end

  defp parse_point(point) do
    [x, y] = String.split(point, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  defp horizontal_or_vertical?({{x1, y1}, {x2, y2}}) do
    x1 == x2 || y1 == y2
  end

  defp generate_board(lines) do
    Enum.reduce(lines, %{}, &add_line/2)
  end

  defp add_line(line, board) do
    Map.merge(board, line_to_points(line), fn _, a, b -> a + b end)
  end

  defp line_to_points(line) do
    if horizontal_or_vertical?(line) do
      horizontal_or_vertical_to_points(line)
    else
      diagonal_to_points(line)
    end
  end

  defp horizontal_or_vertical_to_points({{x1, y1}, {x2, y2}}) do
    for x <- x1..x2, y <- y1..y2, into: %{}, do: {{x, y}, 1}
  end

  defp diagonal_to_points({{x1, _} = point1, {x2, _} = point2}) when x1 > x2 do
    diagonal_to_points({point2, point1})
  end

  defp diagonal_to_points({{x1, y1}, {x2, y2}}) do
    length = abs(x1 - x2)

    if y1 < y2 do
      for step <- 0..length, into: %{}, do: {{x1 + step, y1 + step}, 1}
    else
      for step <- 0..length, into: %{}, do: {{x1 + step, y1 - step}, 1}
    end
  end

  defp count_overlapping(board) do
    board
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end
end
