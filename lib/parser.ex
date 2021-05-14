defmodule GenReport.Parser do
  def parse_file(fileName) do
    "report/#{fileName}"
    |> File.stream!()
    |> Stream.map(&{parse_line(&1)})
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
  end
end
