defmodule HTMLGenerator.HTMLTest do
  use ExUnit.Case, async: true
  require HTMLGenerator.HTML

  # Declare elements we plan to test
  HTMLGenerator.HTML.element(:div)
  HTMLGenerator.HTML.element(:img)
  HTMLGenerator.HTML.element(:br)
  HTMLGenerator.HTML.element(:span)
  HTMLGenerator.HTML.element(:input)
  HTMLGenerator.HTML.element(:p)
  HTMLGenerator.HTML.element(:a)
  HTMLGenerator.HTML.element(:button)

  describe "self-closing (void) elements" do
    test "br renders correctly" do
      assert html_br() == "<br/>"
      assert html_br(class: "spacer") == "<br class=\"spacer\"/>"
    end

    test "img renders correctly" do
      assert html_img() == "<img/>"
      assert html_img(src: "test.jpg") == "<img src=\"test.jpg\"/>"
      assert html_img(src: "test.jpg", alt: "Test") == "<img src=\"test.jpg\" alt=\"Test\"/>"
    end

    test "input renders correctly" do
      assert html_input() == "<input/>"
      assert html_input(type: "text") == "<input type=\"text\"/>"
      assert html_input(type: "checkbox", checked: true) == "<input type=\"checkbox\" checked/>"
      assert html_input(type: "text", placeholder: "Enter name", required: true) ==
               "<input type=\"text\" placeholder=\"Enter name\" required/>"
    end
  end

  describe "container elements" do
    test "div renders correctly" do
      assert html_div() == "<div></div>"
      assert html_div(class: "container") == "<div class=\"container\"></div>"
      assert html_div(do: "Content") == "<div>Content</div>"
      assert html_div([class: "wrapper", id: "main"], do: "Content") ==
               "<div class=\"wrapper\" id=\"main\">Content</div>"
    end

    test "p renders correctly" do
      assert html_p() == "<p></p>"
      assert html_p(class: "text") == "<p class=\"text\"></p>"
      assert html_p(do: "Paragraph") == "<p>Paragraph</p>"
      assert html_p([class: "important"], do: "Read this") ==
               "<p class=\"important\">Read this</p>"
    end

    test "span renders correctly" do
      assert html_span() == "<span></span>"
      assert html_span(class: "highlight") == "<span class=\"highlight\"></span>"
      assert html_span(do: "Text") == "<span>Text</span>"
      assert html_span([class: "badge"], do: "New") ==
               "<span class=\"badge\">New</span>"
    end

    test "a renders correctly" do
      assert html_a() == "<a></a>"
      assert html_a(href: "#") == "<a href=\"#\"></a>"
      assert html_a(do: "Click me") == "<a>Click me</a>"
      assert html_a([href: "https://example.com", target: "_blank"], do: "Visit") ==
               "<a href=\"https://example.com\" target=\"_blank\">Visit</a>"
    end

    test "button renders correctly" do
      assert html_button() == "<button></button>"
      assert html_button(type: "submit") == "<button type=\"submit\"></button>"
      assert html_button(do: "Click me") == "<button>Click me</button>"
      assert html_button([type: "button", class: "primary"], do: "Save") ==
               "<button type=\"button\" class=\"primary\">Save</button>"
    end
  end

  describe "attribute handling" do
    test "handles boolean attributes" do
      assert html_input(disabled: true) == "<input disabled/>"
      assert html_input(readonly: true) == "<input readonly/>"
      assert html_button(disabled: true) == "<button disabled></button>"
    end

    test "handles multiple attributes" do
      assert html_div(id: "main", class: "container", "data-test": "value") ==
               "<div id=\"main\" class=\"container\" data-test=\"value\"></div>"
    end

    test "handles numeric values" do
      assert html_img(width: 100, height: 200) ==
               "<img width=\"100\" height=\"200\"/>"
    end

    test "escapes attribute values" do
      assert html_div(class: "test\"quotes'&<>") ==
               "<div class=\"test&quot;quotes&#39;&amp;&lt;&gt;\"></div>"
    end

    test "filters out nil and empty string attributes" do
      assert html_div(id: nil, class: "", style: "color: red") ==
               "<div style=\"color: red\"></div>"
    end
  end

  describe "nested content" do
    test "handles basic nesting" do
      result = html_div(class: "outer") do
        html_div(class: "inner") do
          "Content"
        end
      end

      assert result == "<div class=\"outer\"><div class=\"inner\">Content</div></div>"
    end

    test "handles multiple nested elements" do
      result = html_div(class: "container") do
        [
          html_p(do: "First paragraph"),
          html_p(do: "Second paragraph")
        ] |> Enum.join("\n")
      end

      assert result == "<div class=\"container\"><p>First paragraph</p>\n<p>Second paragraph</p></div>"
    end

    test "handles deep nesting" do
      result = html_div(class: "level-1") do
        html_div(class: "level-2") do
          html_div(class: "level-3") do
            "Deep content"
          end
        end
      end

      assert result == "<div class=\"level-1\"><div class=\"level-2\"><div class=\"level-3\">Deep content</div></div></div>"
    end
  end

  describe "content handling" do
    test "handles string content" do
      assert html_div(do: "Hello") == "<div>Hello</div>"
    end

    test "handles integer content" do
      assert html_div(do: 42) == "<div>42</div>"
    end

    test "handles nil content" do
      assert html_div(do: nil) == "<div></div>"
    end
  end
end
