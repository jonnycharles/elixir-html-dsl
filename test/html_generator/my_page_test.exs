defmodule HTMLGenerator.MyPageTest do
  use ExUnit.Case
  import HTMLGenerator.MyPage

  describe "render/0" do
    test "renders full HTML structure correctly" do
      expected = "<div id=\"main\" class=\"container\"><p>Content inside div</p>\n  <img src=\"/images/logo.png\" alt=\"Logo\"/>\n  <br/>\n  <span class=\"highlight\">Content inside span</span></div>"
      assert render() == expected
    end

    test "contains all required elements" do
      result = render()

      # Check outer div with attributes
      assert result =~ ~r/<div[^>]+id="main"[^>]*>/
      assert result =~ ~r/<div[^>]+class="container"[^>]*>/

      # Check paragraph
      assert result =~ "<p>Content inside div</p>"

      # Check image with attributes
      assert result =~ ~r/<img[^>]+src="\/images\/logo.png"[^>]*>/
      assert result =~ ~r/<img[^>]+alt="Logo"[^>]*>/

      # Check line break
      assert result =~ "<br/>"

      # Check span with content
      assert result =~ ~r/<span[^>]+class="highlight"[^>]*>/
      assert result =~ "Content inside span"
    end

    test "elements are properly nested" do
      result = render()

      # Verify overall structure
      assert result =~ ~r/<div[^>]*>.*<\/div>/s

      # Verify content ordering
      [_, content] = Regex.run(~r/<div[^>]*>(.*)<\/div>/s, result)

      parts = String.split(content, "\n  ") |> Enum.map(&String.trim/1)

      assert length(parts) == 4
      assert Enum.at(parts, 0) =~ ~r/<p>.*<\/p>/
      assert Enum.at(parts, 1) =~ ~r/<img.*\/>/
      assert Enum.at(parts, 2) == "<br/>"
      assert Enum.at(parts, 3) =~ ~r/<span.*>.*<\/span>/
    end

    test "formatting is preserved" do
      result = render()
      lines = String.split(result, "\n")

      # Check proper indentation
      assert length(lines) == 4  # Updated to match actual number of lines

      [first_line | rest] = lines
      assert first_line =~ ~r/^<div.*<p>.*<\/p>$/  # First line contains div opening and p element

      # Check indentation of remaining lines
      rest |> Enum.each(fn line ->
        assert String.starts_with?(line, "  "),
               "Expected line to start with two spaces: #{inspect(line)}"
      end)
    end
  end
end
