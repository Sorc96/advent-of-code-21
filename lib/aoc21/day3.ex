defmodule Aoc21.Day3 do
  use InputLoader

  def run_a do
    diagnostics()
    |> calculate_power_consumption()
    |> multiply_results()
  end

  def run_b do
    diagnostics()
    |> calculate_life_support()
    |> multiply_results()
  end

  defp diagnostics do
    input_data()
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp calculate_power_consumption(diagnostics) do
    digits = most_common_digits(diagnostics)

    gamma =
      digits
      |> calculate_gamma()
      |> parse_number()

    epsilon =
      digits
      |> calculate_epsilon()
      |> parse_number()

    {gamma, epsilon}
  end

  defp calculate_life_support(diagnostics) do
    oxygen_generator =
      diagnostics
      |> calculate_oxygen_generator()
      |> parse_number()

    co2_scrubber =
      diagnostics
      |> calculate_co2_scrubber()
      |> parse_number()

    {oxygen_generator, co2_scrubber}
  end

  defp most_common_digits(diagnostics) do
    Enum.reduce(diagnostics, List.duplicate(0, 12), fn number, result ->
      number
      |> Enum.map(fn
        "1" -> 1
        "0" -> -1
      end)
      |> sum_lists(result)
    end)
  end

  defp sum_lists(a, b) do
    Enum.map(Enum.zip(a, b), fn {x, y} -> x + y end)
  end

  defp calculate_gamma(digits) do
    Enum.map(digits, fn digit ->
      if digit > 0, do: "1", else: "0"
    end)
  end

  defp calculate_epsilon(digits) do
    Enum.map(digits, fn digit ->
      if digit > 0, do: "0", else: "1"
    end)
  end

  def calculate_oxygen_generator(diagnostics, index \\ 0) do
    digits = most_common_digits(diagnostics)
    keep_digit = if Enum.at(digits, index) < 0, do: "0", else: "1"

    case filter_diagnostics(diagnostics, keep_digit, index) do
      [result] -> result
      multiple -> calculate_oxygen_generator(multiple, index + 1)
    end
  end

  def calculate_co2_scrubber(diagnostics, index \\ 0) do
    digits = most_common_digits(diagnostics)
    keep_digit = if Enum.at(digits, index) < 0, do: "1", else: "0"

    case filter_diagnostics(diagnostics, keep_digit, index) do
      [result] -> result
      multiple -> calculate_co2_scrubber(multiple, index + 1)
    end
  end

  defp filter_diagnostics(diagnostics, keep_digit, index) do
    Enum.filter(diagnostics, fn number ->
      Enum.at(number, index) == keep_digit
    end)
  end

  defp parse_number(digits) do
    digits
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp multiply_results({a, b}), do: a * b
end
