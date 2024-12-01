# part 1

{left, right} = File.read!("1/input.txt")
|> String.split("\n")
|> Enum.map(&String.split(&1, " ", trim: true))
|> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
|> Enum.map(&List.to_tuple/1)
|> Enum.unzip()

left_sorted = Enum.sort(left)
right_sorted = Enum.sort(right)

Enum.zip(left_sorted, right_sorted)
|> Enum.map(fn {l, r} -> abs(l - r) end)
|> Enum.sum()
|> IO.puts()


# part 2

left
|> Enum.map(fn int ->
  Enum.count(right, &(&1 == int)) * int
end)
|> Enum.sum()
|> IO.puts()
