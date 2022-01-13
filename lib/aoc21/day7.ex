defmodule Aoc21.Day7 do
  use InputLoader

  def run_a do
    positions()
    |> find_minimum_fuel(:linear)
  end

  def run_b do
    positions()
    |> find_minimum_fuel(:progressive)
  end

  defp positions do
    input_data()
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp find_minimum_fuel(positions, consumption_mode) do
    {min, max} = Enum.min_max(positions)

    min..max
    |> Enum.map(&fuel_requirement(&1, positions, consumption_mode))
    |> Enum.min()
  end

  defp fuel_requirement(target, positions, consumption_mode) do
    consumption_function =
      case consumption_mode do
        :linear -> &distance(&1, target)
        :progressive -> &sum_series(&1, target)
      end

    positions
    |> Enum.map(consumption_function)
    |> Enum.sum()
  end

  defp distance(a, b), do: abs(a - b)

  defp sum_series(a, b) do
    d = distance(a, b)

    (d * (d + 1)) / 2
    |> round()
  end
end
