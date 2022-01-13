defmodule Aoc21.Day9 do
  use InputLoader

  def run_a do
    parse_heightmap()
    |> lowpoints()
    |> Keyword.values()
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  def run_b do
    parse_heightmap()
    |> basins()
    |> Enum.map(&length/1)
    |> Enum.sort(&>/2)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp parse_heightmap do
    rows = Enum.map(input_data(), &parse_row/1)

    for {row, y} <- Enum.with_index(rows),
        {height, x} <- Enum.with_index(row),
        into: %{},
        do: {{x, y}, height}
  end

  defp parse_row(row) do
    row
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp lowpoints(heightmap) do
    heightmap
    |> Enum.filter(&lowpoint?(&1, heightmap))
  end

  defp lowpoint?({position, height}, heightmap) do
    position
    |> neighbours(heightmap)
    |> Enum.all?(&(&1 > height))
  end

  defp neighbours(position, heightmap) do
    position
    |> neighbouring_positions(heightmap)
    |> Enum.map(&heightmap[&1])
  end

  defp neighbouring_positions({x, y}, heightmap) do
    [{x, y + 1}, {x, y - 1}, {x + 1, y}, {x - 1, y}]
    |> Enum.filter(&Map.has_key?(heightmap, &1))
  end

  defp risk_level(point), do: point + 1

  defp basins(heightmap) do
    heightmap
    |> lowpoints()
    |> Enum.map(fn {position, _} -> find_basin(position, heightmap) end)
  end

  defp find_basin(position, heightmap) do
    search_basin(heightmap, [], [position])
  end

  def search_basin(_, searched, []), do: searched

  def search_basin(heightmap, searched, [next_search | to_be_searched]) do
    new_searches =
      neighbouring_positions(next_search, heightmap)
      |> Enum.reject(&(heightmap[&1] == 9))

    new_searches = new_searches -- searched

    searched =
      if next_search in searched do
        searched
      else
        [next_search | searched]
      end

    search_basin(heightmap, searched, to_be_searched ++ new_searches)
  end
end
