defmodule Aoc21 do
  def run(day, variant) when day in 1..25 and variant in [:a, :b] do
    module = String.to_existing_atom("Elixir.Aoc21.Day#{day}")
    function = String.to_atom("run_#{variant}")
    apply(module, function, [])
  end
end
