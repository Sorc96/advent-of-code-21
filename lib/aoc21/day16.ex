defmodule Aoc21.Day16 do
  use InputLoader

  def run_a do
    {packet, _} =
      input_data()
      |> packet_to_binary()
      |> parse_packet()

    sum_versions(packet)
  end

  def run_b do
    {packet, _} =
      input_data()
      |> packet_to_binary()
      |> parse_packet()

    evaluate(packet)
  end

  defp packet_to_binary(input) do
    input
    |> hd()
    |> String.to_charlist()
    |> Enum.map(&convert/1)
    |> Enum.join()
  end

  defp convert(char) do
    case char do
      ?0 -> "0000"
      ?1 -> "0001"
      ?2 -> "0010"
      ?3 -> "0011"
      ?4 -> "0100"
      ?5 -> "0101"
      ?6 -> "0110"
      ?7 -> "0111"
      ?8 -> "1000"
      ?9 -> "1001"
      ?A -> "1010"
      ?B -> "1011"
      ?C -> "1100"
      ?D -> "1101"
      ?E -> "1110"
      ?F -> "1111"
    end
  end

  defp parse_packet(<<version::binary-size(3), type_id::binary-size(3)>> <> rest) do
    version = String.to_integer(version, 2)
    type_id = String.to_integer(type_id, 2)
    {content, remaining} = parse_content(type_id, rest)

    {%{
       version: version,
       type_id: type_id,
       content: content
     }, remaining}
  end

  defp parse_content(type_id, content) do
    case type_id do
      4 -> parse_literal(content)
      _ -> parse_operator(content)
    end
  end

  defp parse_literal("0" <> <<group::binary-size(4)>> <> rest), do: {group, rest}

  defp parse_literal("1" <> <<group::binary-size(4)>> <> rest) do
    {literal, remaining} = parse_literal(rest)
    {group <> literal, remaining}
  end

  defp parse_operator("0" <> <<length::binary-size(15)>> <> rest) do
    length = String.to_integer(length, 2)
    {content, remaining} = String.split_at(rest, length)

    {parse_packets(content), remaining}
  end

  defp parse_operator("1" <> <<length::binary-size(11)>> <> rest) do
    packet_count = String.to_integer(length, 2)

    Enum.reduce(1..packet_count, {[], rest}, fn _, {result, input} ->
      {packet, remaining} = parse_packet(input)

      {result ++ [packet], remaining}
    end)
  end

  defp parse_packets(content) do
    if String.replace(content, "0", "") == "" do
      []
    else
      {packet, rest} = parse_packet(content)

      [packet | parse_packets(rest)]
    end
  end

  defp sum_versions(%{content: content, version: version}) do
    if is_binary(content) do
      version
    else
      subtotal =
        content
        |> Enum.map(&sum_versions/1)
        |> Enum.sum()

      version + subtotal
    end
  end

  defp evaluate(%{type_id: 4, content: content}) do
    String.to_integer(content, 2)
  end

  defp evaluate(%{type_id: 0, content: content}) do
    content
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  defp evaluate(%{type_id: 1, content: content}) do
    content
    |> Enum.map(&evaluate/1)
    |> Enum.product()
  end

  defp evaluate(%{type_id: 2, content: content}) do
    content
    |> Enum.map(&evaluate/1)
    |> Enum.min()
  end

  defp evaluate(%{type_id: 3, content: content}) do
    content
    |> Enum.map(&evaluate/1)
    |> Enum.max()
  end

  defp evaluate(%{type_id: 5, content: [left, right]}) do
    if evaluate(left) > evaluate(right), do: 1, else: 0
  end

  defp evaluate(%{type_id: 6, content: [left, right]}) do
    if evaluate(left) < evaluate(right), do: 1, else: 0
  end

  defp evaluate(%{type_id: 7, content: [left, right]}) do
    if evaluate(left) == evaluate(right), do: 1, else: 0
  end
end
