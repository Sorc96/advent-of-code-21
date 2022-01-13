defmodule Aoc21.Day12 do
  use InputLoader

  def run_a do
    input_data()
    |> parse_caves()
    |> count_paths(:visit_small_once)
  end

  def run_b do
    input_data()
    |> parse_caves()
    |> count_paths(:visit_single_small_twice)
  end

  defp parse_caves(lines) do
    lines
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, &add_connection/2)
  end

  defp add_connection([from, to], connections) do
    connections
    |> Map.put_new(from, [])
    |> Map.put_new(to, [])
    |> Map.update!(from, fn existing -> [to | existing] end)
    |> Map.update!(to, fn existing -> [from | existing] end)
  end

  defp count_paths(connections, mode) do
    connections
    |> recur_connections("start", [], mode)
    |> List.flatten()
    |> Enum.count()
  end

  defp recur_connections(_, "end", visited, _) do
    Enum.reverse(["end" | visited])
    |> List.to_tuple()
  end

  defp recur_connections(connections, current, visited, mode) do
    connections
    |> available_paths(current, visited, mode)
    |> Enum.map(&recur_connections(connections, &1, [current | visited], mode))
  end

  def available_paths(connections, current, visited, mode) do
    connections[current]
    |> Enum.filter(&can_be_visited?(&1, [current | visited], mode))
  end

  defp can_be_visited?("start", _, _), do: false

  defp can_be_visited?(cave, visited, mode) do
    if "end" in visited do
      false
    else
      case mode do
        :visit_small_once ->
          large?(cave) || cave not in visited

        :visit_single_small_twice ->
          large?(cave) || cave not in visited || no_small_visited_twice?(visited)
      end
    end
  end

  defp large?(cave), do: cave == String.upcase(cave)

  defp no_small_visited_twice?(visited) do
    small_caves = Enum.reject(visited, &large?/1)

    small_caves == Enum.uniq(small_caves)
  end
end
