defmodule Aoc21.Day15 do
  use InputLoader

  def run_a do
    input_data()
    |> parse_graph()
    |> shortest_path("0-0", "99-99")
  end

  def run_b do
    input_data()
    |> copy(5)
    |> parse_graph()
    |> shortest_path("0-0", "499-499")
  end

  defp parse_graph(lines) do
    nodes = parse_nodes(lines)
    edges = Enum.flat_map(nodes, &edges(&1, nodes))
    Graph.add_edges(Graph.new(), edges)
  end

  defp parse_nodes(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> Enum.with_index()
    |> Enum.map(fn {nodes, y} ->
      Enum.map(nodes, fn {risk, x} -> {{x, y}, {"#{x}-#{y}", risk}} end)
    end)
    |> List.flatten()
    |> Map.new()
  end

  defp parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end

  defp edges({position, {name, _}}, nodes) do
    position
    |> neighbours(nodes)
    |> Enum.map(fn {neighbour_name, neighbour_risk} ->
      Graph.Edge.new(name, neighbour_name, weight: neighbour_risk)
    end)
  end

  defp neighbours({x, y}, nodes) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(&Map.has_key?(nodes, &1))
    |> Enum.map(&Map.get(nodes, &1))
  end

  defp shortest_path(graph, from, to) do
    Graph.dijkstra(graph, from, to)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [left, right] -> Graph.edge(graph, left, right).weight end)
    |> Enum.sum()
  end

  defp copy(lines, count) do
    lines
    |> Enum.map(&copy_line(&1, count))
    |> copy_block(count)
    |> Enum.map(fn line ->
      line
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join()
    end)
  end

  defp copy_line(line, count) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.duplicate(count)
    |> Enum.with_index(&increment_line/2)
    |> List.flatten()
  end

  defp copy_block(lines, count) do
    lines
    |> List.duplicate(count)
    |> Enum.with_index()
    |> Enum.flat_map(fn {lines, index} ->
      Enum.map(lines, &increment_line(&1, index))
    end)
  end

  defp increment_line(nodes, by) do
    Enum.map(nodes, fn node ->
      risk = node + by
      if risk > 9, do: risk - 9, else: risk
    end)
  end
end
# 2624 low
# 2741 incorrect
