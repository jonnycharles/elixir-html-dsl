defmodule HTMLGenerator.HTML do
  @void_elements ~w(area base br col embed hr img input link meta param source track wbr)a
  @valid_tags ~w(div span p img br a ul li table tr td th h1 h2 h3 h4 h5 h6 script style button input textarea select option)a

  defmacro element(name) do
    unless name in @valid_tags do
      raise ArgumentError, "Invalid HTML tag: #{name}"
    end

    is_void = name in @void_elements
    function_name = String.to_atom("html_#{name}")

    quote do
      def unquote(function_name)() do
        if unquote(is_void) do
          "<#{unquote(name)}/>"
        else
          "<#{unquote(name)}></#{unquote(name)}>"
        end
      end

      def unquote(function_name)(attrs_or_content)

      def unquote(function_name)(do: content) do
        if unquote(is_void) do
          "<#{unquote(name)}/>"
        else
          "<#{unquote(name)}>#{content}</#{unquote(name)}>"
        end
      end

      def unquote(function_name)(attrs) when is_list(attrs) do
        attrs_string =
          attrs
          |> Enum.filter(fn {_key, value} -> value != nil and value != "" end)
          |> Enum.map(fn
            {key, true} -> Atom.to_string(key)
            {key, value} when is_binary(value) -> "#{Atom.to_string(key)}=\"#{HTMLGenerator.HTML.escape(value)}\""
            {key, value} when is_number(value) -> "#{Atom.to_string(key)}=\"#{value}\""
            _ -> ""
          end)
          |> Enum.filter(&(&1 != ""))
          |> Enum.join(" ")
          |> case do
            "" -> ""
            str -> " " <> str
          end

        if unquote(is_void) do
          "<#{unquote(name)}#{attrs_string}/>"
        else
          "<#{unquote(name)}#{attrs_string}></#{unquote(name)}>"
        end
      end

      def unquote(function_name)(attrs, do: content) when is_list(attrs) do
        attrs_string =
          attrs
          |> Enum.filter(fn {_key, value} -> value != nil and value != "" end)
          |> Enum.map(fn
            {key, true} -> Atom.to_string(key)
            {key, value} when is_binary(value) -> "#{Atom.to_string(key)}=\"#{HTMLGenerator.HTML.escape(value)}\""
            {key, value} when is_number(value) -> "#{Atom.to_string(key)}=\"#{value}\""
            _ -> ""
          end)
          |> Enum.filter(&(&1 != ""))
          |> Enum.join(" ")
          |> case do
            "" -> ""
            str -> " " <> str
          end

        if unquote(is_void) do
          "<#{unquote(name)}#{attrs_string}/>"
        else
          "<#{unquote(name)}#{attrs_string}>#{content}</#{unquote(name)}>"
        end
      end
    end
  end

  def escape(value) when is_binary(value) do
    value
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&#39;")
  end
end
