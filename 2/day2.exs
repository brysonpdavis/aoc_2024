defmodule Day02 do
  defp parse_reports do
    File.read!("2/input.txt")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  defp get_adjacent_pairs(report) do
    Enum.zip(report, tl(report))
  end

  defp all_diffs_within_bounds(report) do
    report
    |> get_adjacent_pairs()
    |> Enum.all?(fn {x, y} -> 1 <= abs(x - y) and abs(x - y) <= 3 end)
  end

  defp all_descending(report) do
    report
    |> get_adjacent_pairs()
    |> Enum.all?(fn {x, y} -> x > y end)
  end

  defp all_ascending(report) do
    report
    |> get_adjacent_pairs()
    |> Enum.all?(fn {x, y} -> x < y end)
  end

  defp is_safe?(report) do
    all_diffs_within_bounds(report) and (all_descending(report) or all_ascending(report))
  end

  def part1 do
    parse_reports()
    |> Enum.count(&is_safe?/1)
    |> IO.puts()
  end

  defp get_all_permutations_of_length_minus_one(report) do
    Enum.map(0..(length(report) - 1), fn i -> List.delete_at(report, i) end)
  end

  defp is_any_permutation_safe?(report) do
    get_all_permutations_of_length_minus_one(report)
    |> Enum.any?(&is_safe?/1)
  end

  def part2 do
    parse_reports()
    |> Enum.count(&is_any_permutation_safe?/1)
    |> IO.puts()
  end
end

Day02.part1()
Day02.part2()
