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
      |> Enum.map(fn y ->
        tuple_grid
        |> get_all_direction_strings_for_coord({x, y})
        |> Enum.count(&String.starts_with?(&1, "XMAS"))
      end)
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
      |> Enum.count(fn y ->
        tuple_grid
        |> get_x_for_coord({x, y})
        |> x_is_xmas?()
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end

  def directions do
    [{1, 0}, {0, 1}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}]
  end

  def get_all_direction_strings_for_coord(grid, coord) do
    directions()
    |> Enum.map(fn direction ->
      get_direction_string(grid, coord, direction)
    end)
  end

  def get_direction_string(grid, {x, y}, {dx, dy}) do
    get_direction_string_idx = fn i ->
      new_x = x + i * dx
      new_y = y + i * dy

      {grid_max_x, grid_max_y} = get_tuple_grid_dimensions(grid)

      if new_x < 0 or new_x >= grid_max_x or new_y < 0 or new_y >= grid_max_y do
        ""
      else
        elem(elem(grid, new_x), new_y)
      end
    end

    0..3
    |> Enum.map(get_direction_string_idx)
    |> Enum.join()
  end

  defp get_x_for_coord(grid, {x, y}) do
    if x < 1 or x >= tuple_size(grid) - 1 or y < 1 or y >= tuple_size(elem(grid, 0)) - 1 do
      nil
    else
      center = elem(elem(grid, x), y)
      up_left = elem(elem(grid, x - 1), y - 1)
      up_right = elem(elem(grid, x - 1), y + 1)
      down_left = elem(elem(grid, x + 1), y - 1)
      down_right = elem(elem(grid, x + 1), y + 1)

      {up_left <> center <> down_right, down_left <> center <> up_right}
    end
  end

  @valid_x_values ["MAS", "SAM"]

  defp x_is_xmas?(nil) do
    false
  end

  defp x_is_xmas?({left, right}) do
    Enum.member?(@valid_x_values, left) and Enum.member?(@valid_x_values, right)
  end

  def get_tuple_grid_dimensions(grid) do
    {tuple_size(grid), tuple_size(elem(grid, 0))}
  end
end

Day04.part1()
Day04.part2()
