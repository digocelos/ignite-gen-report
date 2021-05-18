defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  @file_name "report_test.csv"
  @files_names ["part_1.csv", "part_2.csv", "part_3.csv"]

  describe "build/1" do
    test "When passing file name return a report" do
      {:ok, response} = GenReport.build(@file_name)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Insira o nome de um arquivo"}
    end
  end

  describe "build_from_many/1" do
    test "when a file list is provided, builds the report" do
      {:ok, response} = GenReport.build_from_many(@files_names)
      expected_response = ReportFixture.build()

      assert response === expected_response
    end

    test "when file list not provided, return an error" do
      response = GenReport.build_from_many("")

      expected_response = {:error, "Please provider a list of strings"}

      assert response === expected_response
    end

    test "when file list is empty, return an error" do
      response = GenReport.build_from_many()

      expected_response = {:error, "Please provider a list of strings"}

      assert response === expected_response
    end
  end
end
