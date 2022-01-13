defmodule Aoc21.Day10 do
  use InputLoader

  def run_a do
    input_data()
    |> Enum.map(&parse_chunks/1)
    |> Enum.filter(&corrupted?/1)
    |> Enum.map(&syntax_error_score/1)
    |> Enum.sum()
  end

  def run_b do
    input_data()
    |> Enum.map(&parse_chunks/1)
    |> Enum.reject(&corrupted?/1)
    |> Enum.map(&autocomplete_score/1)
    |> autocomplete_winner()
  end

  defp corrupted?({:corrupted, _}), do: true
  defp corrupted?({:incomplete, _}), do: false

  defp syntax_error_score({:corrupted, invalid_closing}) do
    corrupted_score(invalid_closing)
  end

  defp parse_chunks(line), do: parse_chunks(line, [])

  defp parse_chunks("", open), do: {:incomplete, open}

  defp parse_chunks(<<opening::8>> <> rest, open) when opening in [?(, ?[, ?{, ?<] do
    parse_chunks(rest, [opening | open])
  end

  defp parse_chunks(<<closing::8>> <> rest, [last_open | open]) do
    if matching?(last_open, closing) do
      parse_chunks(rest, open)
    else
      {:corrupted, closing}
    end
  end

  defp matching?(opening, closing) do
    closing == matching_char(opening)
  end

  defp corrupted_score(char) do
    case char do
      ?) -> 3
      ?] -> 57
      ?} -> 1197
      ?> -> 25137
    end
  end

  defp autocomplete_score({:incomplete, open_chunks}) do
    open_chunks
    |> Enum.map(&matching_char/1)
    |> closing_chars_score()
  end

  defp matching_char(opening) do
    case opening do
      ?( -> ?)
      ?[ -> ?]
      ?{ -> ?}
      ?< -> ?>
    end
  end

  defp closing_chars_score(chars) do
    Enum.reduce(chars, 0, fn char, result ->
      result * 5 + closing_char_score(char)
    end)
  end

  defp closing_char_score(char) do
    case char do
      ?) -> 1
      ?] -> 2
      ?} -> 3
      ?> -> 4
    end
  end

  defp autocomplete_winner(scores) do
    sorted = Enum.sort(scores)

    Enum.at(sorted, div(length(sorted), 2))
  end
end
