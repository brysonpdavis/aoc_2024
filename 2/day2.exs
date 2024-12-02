defmodule Day02 do
  defp parse_reports do
    File.read!("2/input.txt")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  defp is_safe?(report) do
    get_adjacent_pairs = fn report -> Enum.zip(report, tl(report)) end

    all_diffs_within_bounds = fn report ->
      Enum.all?(get_adjacent_pairs.(report), fn {x, y} -> 1 <= abs(x - y) and abs(x - y) <= 3 end)
    end

    all_descending = fn report ->
      Enum.all?(get_adjacent_pairs.(report), fn {x, y} -> x > y end)
    end

    all_ascending = fn report ->
      Enum.all?(get_adjacent_pairs.(report), fn {x, y} -> x < y end)
    end

    all_diffs_within_bounds.(report) and (all_descending.(report) or all_ascending.(report))
  end

  def part1 do
    parse_reports()
    |> Enum.count(&is_safe?/1)
    |> IO.puts()
  end

  def part2 do
    get_all_permutations_of_length_minus_one = fn report ->
      Enum.map(0..(length(report) - 1), fn i -> List.delete_at(report, i) end)
    end

    is_any_permutation_safe? = fn report ->
      get_all_permutations_of_length_minus_one.(report)
      |> Enum.any?(&is_safe?/1)
    end

    parse_reports()
    |> Enum.count(is_any_permutation_safe?)
    |> IO.puts()
  end
end

Day02.part1()
Day02.part2()
