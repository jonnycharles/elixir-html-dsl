defmodule HTMLGenerator.MyPage do
  require HTMLGenerator.HTML

  # Define the elements
  HTMLGenerator.HTML.element(:div)
  HTMLGenerator.HTML.element(:p)
  HTMLGenerator.HTML.element(:img)
  HTMLGenerator.HTML.element(:br)
  HTMLGenerator.HTML.element(:span)

  def render do
    html_div(id: "main", class: "container") do
      [
        html_p() do
          "Content inside div"
        end,
        html_img(src: "/images/logo.png", alt: "Logo"),
        html_br(),
        html_span(class: "highlight") do
          "Content inside span"
        end
      ]
      |> Enum.join("\n  ")
    end
  end
end
