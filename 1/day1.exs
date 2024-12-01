defmodule Day01 do
  defp parse do
    File.read!("1/input.txt")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
  end

  def part1 do
    {left, right} = parse()

    Enum.zip(Enum.sort(left), Enum.sort(right))
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    {left, right} = parse()

    counts = Enum.frequencies(right)

    left
    |> Enum.map(fn num ->
      Map.get(counts, num, 0) * num
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day01.part1()
Day01.part2()
