defmodule GenReport do
  @moduledoc """
    Generate reports

    Ten people freelaxed for a company X for five years and the history with all the data
    of each one of these people (name, hours worked, day, month and year) were transferred
    to a CSV file in the following order: name, hours the day (which will vary from 1 to 8 hours),
    day (which will vary from 1 to 30 even for the month of February and without considering leap years)
    referring to the hours of work, month and year (which goes from 2016 to 2020 ).
    In short: ** name **, ** number of hours **, ** day **, ** month ** and ** year **.

    Provides function build/1 to reade and convert file in List
  """

  alias GenReport.Parser

  @avaliable_member [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "danilo",
    "diego",
    "cleiton",
    "rafael",
    "vinicius"
  ]

  @avaliable_months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  @avaliable_years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  # Daniele,h 7,d 29, m 4, a 2018

  @doc """
  Generate report

  ## Parameters
    - fileName : String of a file where read
  """
  def build(fileName) do
    result =
      fileName
      |> Parser.parse_file()
      |> Enum.reduce(report_acc(), fn line, report -> gen_report(line, report) end)

    {:ok, result}
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build_from_many do
    {:error, "Please provider a list of strings"}
  end

  def build_from_many(file_names) when not is_list(file_names) do
    {:error, "Please provider a list of strings"}
  end

  @doc """
  Process many files async
  """
  def build_from_many(file_names) do
    result =
      file_names
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {:ok, {:ok, result}}, report ->
        sum_reports(report, result)
      end)

    {:ok, result}
  end

  defp gen_report([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    new_name = String.downcase(name)

    # Generate all_hours map
    all_hours = gen_all_hours(all_hours, new_name, hours)

    # Generate hours_per_month map
    hours_per_month = gen_hours_per_month(hours_per_month, new_name, hours, month)

    # Generate hours_per_year map
    hours_per_year = gen_hours_per_year(hours_per_year, new_name, hours, year)

    # Build final report
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp gen_all_hours(all_hours, name, hours) do
    Map.put(all_hours, name, all_hours[name] + hours)
  end

  defp gen_hours_per_month(hours_per_month, name, hours, month) do
    calc_hours_month =
      hours_per_month
      |> Map.get(name)
      |> Map.update(@avaliable_months[month], 0, fn curr -> curr + hours end)

    %{hours_per_month | name => calc_hours_month}
  end

  defp sum_reports(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hours_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hours_per_year" => hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2)
    hours_per_month = merge_maps(hours_per_month1, hours_per_month2)
    hours_per_year = merge_maps(hours_per_year1, hours_per_year2)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> calc_merge_maps(value1, value2) end)
  end

  defp calc_merge_maps(val1, val2) when is_map(val1) and is_map(val2) do
    merge_maps(val1, val2)
  end

  defp calc_merge_maps(val1, val2) do
    val1 + val2
  end

  defp gen_hours_per_year(hours_per_year, name, hours, year) do
    calc_hours_year =
      hours_per_year
      |> Map.get(name)
      |> Map.update(year, 0, fn curr -> curr + hours end)

    %{hours_per_year | name => calc_hours_year}
  end

  defp report_acc do
    all_hours = Enum.into(@avaliable_member, %{}, &{&1, 0})
    hours_per_month = Enum.into(@avaliable_member, %{}, &{&1, report_acc_month()})
    hours_per_year = Enum.into(@avaliable_member, %{}, &{&1, report_acc_years()})
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp report_acc_month do
    @avaliable_months
    |> Map.values()
    |> Enum.into(%{}, &{&1, 0})
  end

  defp report_acc_years do
    @avaliable_years
    |> Enum.into(%{}, &{&1, 0})
  end

  defp build_report(all_hours, hours_per_month, hours_per_year),
    do: %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
end
