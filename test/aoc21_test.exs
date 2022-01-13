defmodule Aoc21Test do
  use ExUnit.Case

  test "completes all challenges" do
    Enum.each(cases(), fn {day, variant, expected_output} ->
      assert Aoc21.run(day, variant) == expected_output
    end)
  end

  defp cases do
    [
      {1, :a, 1162},
      {1, :b, 1190},
      {2, :a, 1604850},
      {2, :b, 1685186100},
      {3, :a, 4138664},
      {3, :b, 4273224},
      {4, :a, 38594},
      {4, :b, 21184},
      {5, :a, 4745},
      {5, :b, 18442},
      {6, :a, 349549},
      {6, :b, 1589590444365},
      {7, :a, 337833},
      {7, :b, 96678050},
      {8, :a, 288},
      {8, :b, 940724},
      {9, :a, 588},
      {9, :b, 964712},
      {10, :a, 215229},
      {10, :b, 1105996483},
      {11, :a, 1757},
      {11, :b, 422},
      {12, :a, 4659},
      {12, :b, 148962},
      {13, :a, 710},
      {13, :b, [
        "#### ###  #     ##  ###  #  # #    ### ",
        "#    #  # #    #  # #  # #  # #    #  #",
        "###  #  # #    #    #  # #  # #    #  #",
        "#    ###  #    # ## ###  #  # #    ### ",
        "#    #    #    #  # # #  #  # #    # # ",
        "#### #    ####  ### #  #  ##  #### #  #"]},
      {14, :a, 2988},
      {14, :b, 3572761917024},
      {15, :a, 707},
      # libgraph has a bug related to hash collisions with large numbers of vertices
      # It is fixed in a PR, uncomment this test after upgrading to the new version
      # {15, :b, 2942},
      {16, :a, 965},
      {16, :b, 116672213160},
      {17, :a, 3003},
      {17, :b, 940},
      {18, :a, 4365},
      {18, :b, 4490}
    ]
  end
end
