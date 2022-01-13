defmodule Aoc21.Day4 do
  use InputLoader

  def run_a do
    parse_bingo()
    |> first_winning_score()
  end

  def run_b do
    parse_bingo()
    |> last_winning_score()
  end

  defp parse_bingo do
    [number_line | board_lines] = input_data()

    {parse_numbers(number_line), parse_boards(board_lines)}
  end

  defp parse_numbers(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(lines) do
    lines
    |> Enum.chunk_by(fn line -> line == "" end)
    |> Enum.reject(fn line -> line == [""] end)
    |> Enum.map(&parse_board/1)
  end

  defp parse_board(board) do
    Enum.map(board, fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp first_winning_score({numbers, boards}) do
    {board, winning_numbers} =
      boards
      |> first_winning_board(numbers)

    score_for(board, winning_numbers) * hd(winning_numbers)
  end

  defp first_winning_board(boards, [next_mark | to_be_marked], marked \\ []) do
    case Enum.find(boards, &winning?(&1, marked)) do
      nil -> first_winning_board(boards, to_be_marked, [next_mark | marked])
      board -> {board, marked}
    end
  end

  defp last_winning_score({numbers, boards}) do
    {board, winning_numbers} =
      boards
      |> last_winning_board(numbers)

    score_for(board, winning_numbers) * hd(winning_numbers)
  end

  defp last_winning_board(boards, to_be_marked, marked \\ [])
  defp last_winning_board([board], _, marked), do: {board, marked}
  defp last_winning_board(boards, [next_mark | to_be_marked], marked) do
    boards
    |> Enum.reject(&winning?(&1, marked))
    |> last_winning_board(to_be_marked, [next_mark | marked])
  end

  defp winning?(board, marked) do
    row_marked?(board, marked) || column_marked?(board, marked)
  end

  defp row_marked?(board, marked) do
    Enum.any?(board, fn row -> row -- marked == [] end)
  end

  defp column_marked?(board, marked) do
    board
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> row_marked?(marked)
  end

  defp score_for(board, marked) do
    board
    |> unmarked_numbers(marked)
    |> Enum.sum()
  end

  defp unmarked_numbers(board, marked) do
    all_numbers(board) -- marked
  end

  defp all_numbers(board) do
    List.flatten(board)
  end
end
