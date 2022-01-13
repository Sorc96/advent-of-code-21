defmodule Aoc21.Day18 do
  use InputLoader

  def run_a do
    input_data()
    |> parse_all()
    |> sum_numbers()
    |> magnitude()
  end

  def run_b do
    input_data()
    |> parse_all()
    |> largest_magnitude()
  end

  defp parse_all(lines) do
    Enum.map(lines, fn line ->
      {number, ""} = parse_number(line)
      number
    end)
  end

  defp parse_number(input) do
    if input =~ ~r/^\d/ do
      parse_regular(input)
    else
      parse_composite(input)
    end
  end

  defp parse_regular(input) do
    [_, number, rest] = Regex.run(~r/(\d+)(.*)/, input)
    {String.to_integer(number), rest}
  end

  defp parse_composite(input) do
    "[" <> rest = input
    {left, rest_after_left} = parse_number(rest)
    "," <> rest_after_comma = rest_after_left
    {right, rest_after_right} = parse_number(rest_after_comma)
    "]" <> remaining = rest_after_right
    {{left, right}, remaining}
  end

  def sum_numbers(numbers) do
    Enum.reduce(numbers, fn next, result -> reduce({result, next}) end)
  end

  defp reduce(number) do
    case try_explode(number, 0) do
      {false, _} ->
        case try_split(number) do
          {false, _} -> number
          {true, split} -> reduce(split)
        end

      {true, exploded, {_, _}} ->
        reduce(exploded)
    end
  end

  defp try_explode(number, _depth) when is_integer(number), do: {false, number}

  defp try_explode(number, 4) do
    {true, 0, number}
  end

  defp try_explode({left, right}, depth) do
    case try_explode(left, depth + 1) do
      {true, new_left, {left_rem, right_rem}} ->
        {true, {new_left, add_to_leftmost(right, right_rem)}, {left_rem, 0}}

      {false, _} ->
        case try_explode(right, depth + 1) do
          {true, new_right, {left_rem, right_rem}} ->
            {true, {add_to_rightmost(left, left_rem), new_right}, {0, right_rem}}

          {false, _} ->
            {false, {left, right}}
        end
    end
  end

  defp add_to_leftmost(number, amount) when is_integer(number), do: number + amount
  defp add_to_leftmost({left, right}, amount), do: {add_to_leftmost(left, amount), right}

  defp add_to_rightmost(number, amount) when is_integer(number), do: number + amount
  defp add_to_rightmost({left, right}, amount), do: {left, add_to_rightmost(right, amount)}

  defp try_split(number) when is_integer(number) do
    if number >= 10 do
      {true, {floor(number / 2), ceil(number / 2)}}
    else
      {false, number}
    end
  end

  defp try_split({left, right}) do
    {left_found, processed_left} = try_split(left)

    if left_found do
      {true, {processed_left, right}}
    else
      {right_found, processed_right} = try_split(right)
      {right_found, {left, processed_right}}
    end
  end

  defp magnitude(number) when is_integer(number), do: number
  defp magnitude({left, right}), do: 3 * magnitude(left) + 2 * magnitude(right)

  defp largest_magnitude(numbers) do
    numbers
    |> all_magnitudes()
    |> Enum.max()
  end

  defp all_magnitudes(numbers) do
    numbers
    |> Enum.flat_map(fn number ->
      numbers
      |> Enum.map(fn other ->
        sum_numbers([number, other])
        |> magnitude()
      end)
    end)
  end
end
