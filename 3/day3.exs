defmodule Day03Again do
  defp read do
    File.read!("3/input.txt")
  end

  def part1 do
    read()
    |> Parser.Part1.parse(:start)
    |> IO.inspect()
  end

  def part2 do
    read()
    |> Parser.Part2.parse(:start)
    |> IO.inspect()
  end
end

# states are named after what was most recently found: start, mul, comma
defmodule Parser do
  def get_slice_after_match(str, {match_idx, match_len}) do
    str
    |> String.slice((match_idx + match_len)..-1//1)
  end

  defmodule Part1 do
    @segment_start_string "mul("

    @segment_end_string ")"

    @segment_separator_str ","

    def parse(str, :start) do
      case :binary.match(str, @segment_start_string) do
        :nomatch ->
          0

        match ->
          Parser.get_slice_after_match(str, match)
          |> parse(:mul)
      end
    end

    def parse(str, :mul) do
      case Integer.parse(str) do
        :error -> parse(str, :start)
        {num, @segment_separator_str <> remainder} -> parse(remainder, :comma, num)
        _ -> parse(str, :start)
      end
    end

    def parse(str, :comma, num) do
      case Integer.parse(str) do
        :error -> parse(str, :start)
        {num2, @segment_end_string <> remainder} -> num * num2 + parse(remainder, :start)
        _ -> parse(str, :start)
      end
    end
  end

  defmodule Part2 do
    @segment_start_string "mul("

    @segment_end_string ")"

    @segment_separator_str ","

    @activate_str "do()"

    @deactivate_str "don't()"

    def parse(str, :start) do
      off_match_result = :binary.match(str, @deactivate_str)
      start_match_result = :binary.match(str, @segment_start_string)

      case {off_match_result, start_match_result} do
        {_, :nomatch} ->
          0

        {:nomatch, match} ->
          Parser.get_slice_after_match(str, match)
          |> parse(:mul)

        {{off_match_idx, off_match_len}, {start_match_idx, start_match_len}}
        when off_match_idx < start_match_idx ->
          Parser.get_slice_after_match(str, {off_match_idx, off_match_len})
          |> parse(:off)

        {{off_match_idx, off_match_len}, {start_match_idx, start_match_len}} ->
          Parser.get_slice_after_match(str, {start_match_idx, start_match_len})
          |> parse(:mul)
      end
    end

    def parse(str, :mul) do
      case Integer.parse(str) do
        :error -> parse(str, :start)
        {num, @segment_separator_str <> remainder} -> parse(remainder, :comma, num)
        _ -> parse(str, :start)
      end
    end

    def parse(str, :off) do
      case :binary.match(str, @activate_str) do
        :nomatch ->
          0

        match ->
          Parser.get_slice_after_match(str, match)
          |> parse(:start)
      end
    end

    def parse(str, :comma, num) do
      case Integer.parse(str) do
        :error -> parse(str, :start)
        {num2, @segment_end_string <> remainder} -> num * num2 + parse(remainder, :start)
        _ -> parse(str, :start)
      end
    end
  end
end

Day03Again.part1()
Day03Again.part2()
