defmodule Aoc21.Day11 do
  use InputLoader

  def run_a do
    input_data()
    |> parse_octopuses()
    |> count_flashes_after_steps(100)
  end

  def run_b do
    input_data()
    |> parse_octopuses()
    |> find_synchronized_flash()
  end

  defp parse_octopuses(lines) do
    lines = Enum.map(lines, &String.split(&1, "", trim: true))

    for {line, y} <- Enum.with_index(lines),
        {energy, x} <- Enum.with_index(line),
        into: %{},
        do: {{x, y}, {false, String.to_integer(energy)}}
  end

  defp count_flashes_after_steps(octopuses, steps) do
    Enum.reduce(1..steps, {octopuses, 0}, fn _, {state, flashes} ->
      {new_state, new_flashes} = step(state)
      {new_state, flashes + new_flashes}
    end)
    |> elem(1)
  end

  defp step(octopuses) do
    new_state =
      octopuses
      |> transform_values(&charge/1)
      |> flash_all()

    {discharge_flashed(new_state), count_flashed(new_state)}
  end

  defp charge({flashed, energy}), do: {flashed, energy + 1}

  defp flash_all(octopuses) do
    result = recur_flash_all(octopuses, {0, 0})

    if result == octopuses do
      result
    else
      flash_all(result)
    end
  end

  defp recur_flash_all(octopuses, {_, 10}), do: octopuses

  defp recur_flash_all(octopuses, {x, y} = position) do
    octopus = octopuses[position]

    neighbours = neighbours(octopuses, position)

    updated_neighbours =
      if will_flash?(octopus) do
        transform_values(neighbours, &charge/1)
      else
        neighbours
      end

    result =
      octopuses
      |> Map.put(position, try_flash(octopus))
      |> Map.merge(updated_neighbours)

    next_position = if x == 9, do: {0, y + 1}, else: {x + 1, y}

    recur_flash_all(result, next_position)
  end

  defp will_flash?({flashed, energy}), do: !flashed && energy > 9

  defp try_flash({_, energy}), do: {energy > 9, energy}

  defp neighbours(octopuses, {x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x - 1, y - 1}
    ]
    |> Enum.filter(&Map.has_key?(octopuses, &1))
    |> Map.new(fn position -> {position, octopuses[position]} end)
  end

  defp discharge_flashed(octopuses) do
    transform_values(octopuses, fn {flashed, energy} ->
      new_energy = if flashed, do: 0, else: energy
      {false, new_energy}
    end)
  end

  defp count_flashed(octopuses) do
    octopuses
    |> Map.values()
    |> Enum.count(fn {flashed, _} -> flashed end)
  end

  defp transform_values(input, transformation) when is_map(input) do
    Map.new(input, fn {key, value} ->
      {key, transformation.(value)}
    end)
  end

  defp find_synchronized_flash(octopuses, steps \\ 1) do
    {new_state, flashes} = step(octopuses)

    if flashes == 100 do
      steps
    else
      find_synchronized_flash(new_state, steps + 1)
    end
  end
end
