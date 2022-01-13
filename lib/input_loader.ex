defmodule InputLoader do
  defmacro __using__(_opts) do
    quote do
      def input_data do
        day =
          __MODULE__
          |> Atom.to_string()
          |> String.split(".")
          |> List.last()
          |> String.downcase()

        path = "data/#{day}.txt"

        path
        |> File.read!()
        |> String.split("\n")
      end
    end
  end
end
