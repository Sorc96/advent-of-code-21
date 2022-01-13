defmodule Aoc21.Day6 do
  use InputLoader

  def run_a do
    parse_fish()
    |> simulate_days(80)
    |> total()
  end

  def run_b do
    parse_fish()
    |> simulate_days(256)
    |> total()
  end

  defp parse_fish do
    input_data()
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp simulate_days(fish, 0), do: fish

  defp simulate_days(fish, days) when days > 0 do
    fish
    |> Enum.map(&tick/1)
    |> Enum.reduce(%{}, &accumulate_groups/2)
    |> simulate_days(days - 1)
  end

  defp accumulate_groups(group, result) do
    Map.merge(result, group, fn _, count1, count2 ->
      count1 + count2
    end)
  end

  defp tick({0, count}), do: %{6 => count, 8 => count}
  defp tick({timer, count}), do: %{(timer - 1) => count}

  defp total(fish) do
    fish
    |> Enum.map(fn {_, count} -> count end)
    |> Enum.sum()
  end
end
