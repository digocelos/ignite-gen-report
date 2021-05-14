defmodule GenReport do
  alias GenReport.Parser

  def build(fileName) do
    fileName
    |> Parser.parse_file()
    |> Enum.each(fn line -> IO.puts(line) end)
  end
end
