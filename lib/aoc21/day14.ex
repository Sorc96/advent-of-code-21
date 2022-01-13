defmodule Aoc21.Day14 do
  use InputLoader

  def run_a do
    {template, rules} = parse_input()

    template
    |> apply_rules(rules, 10)
    |> calculate_result()
  end

  def run_b do
    {template, rules} = parse_input()

    template
    |> apply_rules(rules, 40)
    |> calculate_result()
  end

  defp parse_input do
    [template_line, _ | rule_lines] = input_data()

    {parse_template(template_line), parse_rules(rule_lines)}
  end

  defp parse_template(line) do
    line
    |> String.split("", trim: true)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.frequencies()
  end

  defp parse_rules(lines) do
    for line <- lines, into: %{} do
      [_, key, value] = Regex.run(~r/(\w\w) -> (\w)/, line)
      [left, right] = String.split(key, "", trim: true)
      {{left, right}, value}
    end
  end

  defp apply_rules(polymer, _, 0), do: polymer

  defp apply_rules(polymer, rules, steps) do
    polymer
    |> Enum.reduce(%{}, &try_insert_element(&1, &2, rules))
    |> apply_rules(rules, steps - 1)
  end

  defp try_insert_element({{left, right} = key, count}, result, rules) do
    new_pairs =
      case rules[key] do
        nil ->
          %{key => count}

        element ->
          %{
            {left, element} => count,
            {element, right} => count
          }
      end

    Map.merge(result, new_pairs, fn _, count1, count2 -> count1 + count2 end)
  end

  defp calculate_result(polymer) do
    {min, max} =
      polymer
      |> Enum.reduce(%{}, &merge_frequencies/2)
      |> Map.values()
      |> Enum.map(&normalize/1)
      |> Enum.min_max()

    max - min
  end

  defp merge_frequencies({{left, right}, count}, result) do
    result
    |> Map.update(left, count, fn current -> current + count end)
    |> Map.update(right, count, fn current -> current + count end)
  end

  defp normalize(count) do
    require Integer

    if Integer.is_even(count) do
      div(count, 2)
    else
      div(count, 2) + 1
    end
  end
end
