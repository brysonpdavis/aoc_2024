

# parse
levels = File.read!("2/input.txt")
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " ", trim: true))
  |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))

get_adjacent_pairs = fn list -> Enum.zip(list, tl(list)) end

# part 1
all_diffs_within_bounds = fn list -> Enum.all?(get_adjacent_pairs.(list), fn {x, y} -> 1 <= abs(x - y) and abs(x - y) <= 3 end) end
all_descending = fn list -> Enum.all?(get_adjacent_pairs.(list), fn {x, y} -> x > y end) end
all_ascending = fn list -> Enum.all?(get_adjacent_pairs.(list), fn {x, y} -> x < y end) end
is_safe? = fn list -> all_diffs_within_bounds.(list) and (all_descending.(list) or all_ascending.(list)) end

num_safe_reports = Enum.count(levels, is_safe?)

IO.inspect(num_safe_reports)

# part 2
get_all_permutations_of_length_minus_one = fn list -> Enum.map(0..(length(list) - 1), fn i -> List.delete_at(list, i) end) end

num_safe_reports = Enum.count(levels, fn list -> Enum.any?(get_all_permutations_of_length_minus_one.(list), is_safe?) end)

IO.inspect(num_safe_reports)
