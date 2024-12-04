defmodule Day03 do
  defp read do
    File.read!("3/input.txt")
  end

  def segment_start_string do
    "mul("
  end

  defp segment_end_string do
    ")"
  end

  defp segment_separator_str do
    ","
  end

  def find_all_indexes_of_substring(string, substring, plus \\ 0) do
    string
    |> :binary.match(segment_start_string())
    |> case do
      :nomatch ->
        []

      {idx, _} ->
        [
          idx + plus
          | find_all_indexes_of_substring(
              String.slice(string, idx + 1, String.length(string) + idx + 1),
              substring,
              plus + idx + 1
            )
        ]
    end
  end

  def part1 do
    input_str = read()

    find_all_indexes_of_substring(input_str, segment_start_string())
    |> Enum.map(&(&1 + String.length(segment_start_string())))
    |> Enum.map(fn start_index ->
      res =
        :binary.match(
          String.slice(input_str, start_index, String.length(input_str)),
          segment_end_string()
        )

      case res do
        :nomatch ->
          nil

        {end_index, _} ->
          String.slice(input_str, start_index, end_index)
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(&String.split(&1, segment_separator_str()))
    # parse int pairs
    |> Enum.map(fn
      [x, y] ->
        case {Integer.parse(x), Integer.parse(y)} do
          {{x_int, ""}, {y_int, ""}} -> x_int * y_int
          _ -> nil
        end

      _ ->
        nil
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.sum()
    |> IO.puts()
  end
end

Day03.part1()

# going to take more of a state machine approach
defmodule Day03Try2 do
  defp read do
    File.read!("3/input.txt")
  end

  def segment_start_string do
    "mul("
  end

  defp segment_end_string do
    ")"
  end

  defp segment_separator_str do
    ","
  end

end
