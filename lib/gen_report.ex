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
  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(fileName) do
    fileName
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> gen_report(line, report) end)
  end

  defp gen_report([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = gen_all_hours(all_hours, String.downcase(name), hours)
    hours_per_month = gen_hours_per_month(hours_per_month, String.downcase(name), hours, month)
    hours_per_year = gen_hours_per_year(hours_per_year, String.downcase(name), hours, year)

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

  defp gen_hours_per_year(hours_per_year, name, hours, year) do
    calc_hours_year =
      hours_per_year
      |> Map.get(name)
      |> Map.update(year, 0, fn curr -> curr + hours end)

    %{hours_per_year | name => calc_hours_year}
  end

  defp report_acc() do
    all_hours = Enum.into(@avaliable_member, %{}, &{&1, 0})
    hours_per_month = Enum.into(@avaliable_member, %{}, &{&1, report_acc_month()})
    hours_per_year = Enum.into(@avaliable_member, %{}, &{&1, report_acc_years()})
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp report_acc_month() do
    @avaliable_months
    |> Map.values()
    |> Enum.into(%{}, &{&1, 0})
  end

  defp report_acc_years() do
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
