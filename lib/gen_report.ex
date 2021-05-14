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
    "Daniele",
    "Mayk",
    "Giuliano",
    "Cleiton",
    "Jakeliny",
    "Joseph",
    "Danilo",
    "Diego",
    "Cleiton",
    "Rafael",
    "Vinicius"
  ]

  @doc """
  Generate report

  ## Parameters
    - fileName : String of a file where read
  """
  def build(fileName) do
    fileName
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> report_all_hours(line, report) end)
  end

  defp report_all_hours([name, hours, _month, _day, _year], %{"all_hours" => all_hours}) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    build_report(all_hours)
  end

  def report_acc() do
    all_hours = Enum.into(@avaliable_member, %{}, &{&1, 0})

    build_report(all_hours)
  end

  defp build_report(all_hours), do: %{"all_hours" => all_hours}
end
