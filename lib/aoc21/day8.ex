defmodule Aoc21.Day8 do
  use InputLoader

  def run_a do
    digits()
    |> Enum.count(&unique_segments?/1)
  end

  def run_b do
    input_data()
    |> Enum.map(fn line ->
      line
      |> parse_line()
      |> decode_number()
    end)
    |> Enum.sum()
  end

  defp digits do
    input_data()
    |> Enum.flat_map(fn line ->
      line
      |> String.split("|")
      |> List.last()
      |> String.split(" ", trim: true)
    end)
  end

  defp unique_segments?(digit) do
    String.length(digit) in [2, 3, 4, 7]
  end

  defp parse_line(line) do
    line
    |> String.split("|")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> List.to_tuple()
  end

  defp decode_number({examples, input_digits}) do
    segment_map = make_segment_map(examples)

    input_digits
    |> Enum.map(&decode_segments(&1, segment_map))
    |> Enum.map(&segments_to_digit/1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp make_segment_map(examples) do
    examples = Enum.map(examples, &String.to_charlist/1)

    one = find_by_segment_count(examples, 2)
    four = find_by_segment_count(examples, 4)
    seven = find_by_segment_count(examples, 3)

    a = hd(seven -- one)
    b = find_by_occurences(examples, 6)
    c = hd(select_occurences(examples, 8) -- [a])
    e = find_by_occurences(examples, 4)
    f = find_by_occurences(examples, 9)
    d = hd(four -- [b, c, f])
    g = hd('abcdefg' -- [a, b, c, d, e, f])

    %{a => 'a', b => 'b', c => 'c', d => 'd', e => 'e', f => 'f', g => 'g'}
  end

  defp find_by_segment_count(digits, count) do
    Enum.find(digits, fn digit -> length(digit) == count end)
  end

  defp find_by_occurences(digits, count) do
    digits
    |> select_occurences(count)
    |> hd()
  end

  defp select_occurences(digits, count) do
    Enum.filter('abcdefg', fn segment ->
      Enum.count(digits, fn digit -> segment in digit end) == count
    end)
  end

  defp decode_segments(segments, mapping) do
    segments
    |> String.to_charlist()
    |> Enum.map(fn segment -> mapping[segment] end)
    |> List.to_string()
  end

  defp segments_to_digit(segments) do
    case sort_segments(segments) do
      "abcefg" -> "0"
      "cf" -> "1"
      "acdeg" -> "2"
      "acdfg" -> "3"
      "bcdf" -> "4"
      "abdfg" -> "5"
      "abdefg" -> "6"
      "acf" -> "7"
      "abcdefg" -> "8"
      "abcdfg" -> "9"
    end
  end

  defp sort_segments(segments) do
    segments
    |> String.to_charlist()
    |> Enum.sort()
    |> List.to_string()
  end
end
