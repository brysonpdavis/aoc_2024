defmodule Day04 do
  def read_and_parse do
    File.read!("4/input.txt")
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def list_grid_to_tuple_grid(grid) do
    grid
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def part1 do
    list_grid = read_and_parse()
    tuple_grid = list_grid_to_tuple_grid(list_grid)

    0..length(list_grid)
    |> Enum.map(fn x ->
      0..tuple_size(elem(tuple_grid, 0))
      |> Enum.map(&get_all_direction_strings_for_coord(tuple_grid, {x, &1}))
      |> List.flatten()
      |> Enum.map(&String.starts_with?(&1, "XMAS"))
      |> Enum.count(fn x -> x == true end)
    end)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2 do
    list_grid = read_and_parse()
    tuple_grid = list_grid_to_tuple_grid(list_grid)

    0..length(list_grid)
    |> Enum.map(fn x ->
      0..tuple_size(elem(tuple_grid, 0))
      # v replace with function to map a grid and a space to the X
      |> Enum.map(&get_all_direction_strings_for_coord(tuple_grid, {x, &1}))
      # v replace with function to count the number of XMAS strings
      |> Enum.map(&String.starts_with?(&1, "XMAS"))
      |> Enum.count(fn x -> x == true end)
    end)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end

  def directions do
    [{1, 0}, {0, 1}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}]
  end

  def get_all_direction_strings_for_coord(grid, {x, y}) do
    directions()
    |> Enum.map(fn {dx, dy} ->
      get_direction_string(grid, {x, y}, {dx, dy})
    end)
  end

  def get_direction_string(grid, {x, y}, {dx, dy}) do
    Enum.reduce_while(0..3, "", fn i, acc ->
      new_x = x + i * dx
      new_y = y + i * dy

      {grid_max_x, grid_max_y} = get_tuple_grid_dimensions(grid)

      if new_x < 0 or new_x >= grid_max_x or new_y < 0 or new_y >= grid_max_y do
        {:halt, acc}
      else
        case elem(elem(grid, new_x), new_y) do
          nil ->
            {:cont, acc}

          val ->
            {:cont, acc <> val}
        end
      end
    end)
  end

  def get_tuple_grid_dimensions(grid) do
    {tuple_size(grid), tuple_size(elem(grid, 0))}
  end
end

Day04.part1()
