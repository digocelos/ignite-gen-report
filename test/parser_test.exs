defmodule GenReport.ParserTest do
  use ExUnit.Case

  alias GenReport.Parser

  describe "parse_file/1" do
    test "parses the file" do
      file_name = "report_test.csv"

      response =
        file_name
        |> Parser.parse_file()
        |> Enum.member?(["Daniele", 7, 29, 4, 2018])

      assert response == true
    end
  end
end
