defmodule Aoc21.Day17 do
  use InputLoader

  def run_a do
    {_, y_range} =
      input_data()
      |> parse_ranges

    y_range
    |> find_maximum_vy()
    |> highest_point(0)
  end

  def run_b do
    {x_range, y_range} =
      input_data()
      |> parse_ranges

    count_available_velocities(x_range, y_range)
  end

  defp parse_ranges(input) do
    line = hd(input)
    [x1, x2, y1, y2] =
      Regex.run(~r/target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/, line)
      |> tl()
      |> Enum.map(&String.to_integer/1)

    {x1..x2, y1..y2}
  end

  defp find_maximum_vy(y_range) do
    y_range
    |> available_y_velocities()
    |> Enum.sort()
    |> List.last()
  end

  defp count_available_velocities(x_range, y_range) do
    vxs = available_x_velocities(x_range)
    vys = available_y_velocities(y_range)
    velocities = for vx <- vxs, vy <- vys, do: {vx, vy}

    Enum.count(velocities, &can_reach?({0, 0}, &1, x_range, y_range))
  end

  defp can_reach?(position, velocity, x_range, y_range) do
    {{x, y}, new_velocity} = tick(position, velocity)

    cond do
      x in x_range and y in y_range -> true
      y < y_range.first -> false
      true -> can_reach?({x, y}, new_velocity, x_range, y_range)
    end
  end

  defp tick({x, y}, {vx, vy}) do
    {{x + vx, y + vy}, {slow_down(vx), vy - 1}}
  end

  defp slow_down(0), do: 0
  defp slow_down(x) when x > 0, do: x - 1
  defp slow_down(x) when x < 0, do: x + 1

  defp available_x_velocities(range) do
    Enum.filter(1..range.last, &can_reach_x?(0, &1, range))
  end

  defp available_y_velocities(range) do
    Enum.filter(range.first..1000, &can_reach_y?(0, &1, range))
  end

  defp can_reach_x?(position, velocity, range) do
    cond do
      position in range -> true
      velocity < 1 -> false
      position > range.last -> false
      true -> can_reach_x?(position + velocity, velocity - 1, range)
    end
  end

  defp can_reach_y?(position, velocity, range) do
    cond do
      position in range -> true
      position < range.first -> false
      true -> can_reach_y?(position + velocity, velocity - 1, range)
    end
  end

  defp highest_point(velocity, position) when velocity <= 0, do: position

  defp highest_point(velocity, position) do
    highest_point(velocity - 1, position + velocity)
  end
end
