defmodule Day05 do
  defp read_input do
    File.read!("5/input.txt")
  end

  @type rule :: {binary(), binary()}
  @type update :: list(binary())

  @spec parse_rule(binary()) :: rule()
  defp parse_rule(rule_string) do
    rule_string
    |> String.split("|")
    |> List.to_tuple()
  end

  @spec parse_rules(binary()) :: list(rule())
  defp parse_rules(rules_string) do
    rules_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rule/1)
  end

  @spec parse_update(binary()) :: update()
  defp parse_update(update_string) do
    update_string
    |> String.split(",", trim: true)
  end

  @spec parse_updates(binary()) :: list(update())
  defp parse_updates(updates_string) do
    updates_string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_update/1)
  end

  @spec parse_input(String.t()) ::
          {rules :: list(rule()), updates :: list(update())}
  defp parse_input(input_string) do
    [rules_string, updates_string] =
      input_string
      |> String.split("\n\n", trim: true)

    rules = parse_rules(rules_string)

    updates = parse_updates(updates_string)

    {rules, updates}
  end

  defp list_intersection(list1, list2) do
    list1
    |> Enum.filter(fn x -> Enum.member?(list2, x) end)
  end

  defp get_pages_after_cur(cur_page, rules) do
    rules
    |> Enum.filter(fn {before_page, _} -> before_page == cur_page end)
    |> Enum.map(fn {_, after_page} -> after_page end)
  end

  defp get_pages_before_cur(cur_page, rules) do
    rules
    |> Enum.filter(fn {_, after_page} -> after_page == cur_page end)
    |> Enum.map(fn {before_page, _} -> before_page end)
  end

  defp is_update_correct?(_, []) do
    true
  end

  defp is_update_correct?({_, []}, _) do
    true
  end

  # first element of the tuple is prior pages, second element is later pages
  defp is_update_correct?({prior, [cur_page | later]}, rules) do
    pages_after_cur = get_pages_after_cur(cur_page, rules)
    pages_before_cur = get_pages_before_cur(cur_page, rules)

    out_of_order_pages =
      list_intersection(prior, pages_after_cur) ++ list_intersection(later, pages_before_cur)

    if Enum.empty?(out_of_order_pages) do
      is_update_correct?({[cur_page | prior], later}, rules)
    else
      false
    end
  end

  defp is_update_correct?(update, rules) when is_list(update) do
    is_update_correct?({[], update}, rules)
  end

  defp find_middle_page(update) do
    middle_idx =
      update
      |> length()
      |> div(2)

    Enum.at(update, middle_idx)
  end

  defp get_update_middle_page_number(update) do
    update
    |> find_middle_page()
    |> String.to_integer()
  end

  def part1 do
    {rules, updates} =
      read_input()
      |> parse_input()

    updates
    |> Enum.filter(&is_update_correct?(&1, rules))
    |> Enum.map(&get_update_middle_page_number/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp sort_pages(update, rules) do
    update
    |> Enum.sort(fn first, second ->
      pages_before_first = get_pages_before_cur(first, rules)
      pages_after_second = get_pages_after_cur(second, rules)

      Enum.member?(pages_before_first, second) or Enum.member?(pages_after_second, first)
    end)
  end

  def part2 do
    {rules, updates} =
      read_input()
      |> parse_input()

    updates
    |> Enum.reject(&is_update_correct?(&1, rules))
    |> Enum.map(&(sort_pages(&1, rules) |> get_update_middle_page_number()))
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day05.part1()
Day05.part2()
