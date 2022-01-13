defmodule Aoc21.Day1 do
  use InputLoader

  def run_a do
    measurements()
    |> count_increasing()
  end

  def run_b do
    measurements()
    |> sliding_window(3)
    |> count_increasing()
  end

  defp measurements do
    input_data()
    |> Enum.map(&String.to_integer/1)
  end

  defp count_increasing(measurements) do
    measurements
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  defp sliding_window(measurements, size) do
    measurements
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.map(&Enum.sum/1)
  end
end
