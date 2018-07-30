defmodule Wiki do
  require IEx
  @url_base_link "https://en.wikipedia.org/wiki/"
  @wiki_black_list ~w(/wiki/File: /wiki/Category: /wiki/Special: /wiki/Wikipedia: /wiki/Portal: /wiki/Talk: /wiki/Help: /wiki/Main_Page)
  @link_word_map %{link: []}

  def get_links(params) do
    start_word =
      HTTPoison.get(@url_base_link <> "#{params["start_word"]}")
      |> process_response_body()

    last_word =
      HTTPoison.get(@url_base_link <> "#{params["last_word"]}")
      |> process_response_body()

    compare(start_word, last_word)
  end

  def process_response_body({:ok, html}) do
    wiki_links_list =
      html.body
      |> Floki.parse()
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.map(fn(link) ->
        case String.starts_with?(link, "/wiki/") do
          true ->
            case String.starts_with?(link, @wiki_black_list) do
              true -> nil
              false -> link
            end
          false ->  nil
        end
      end)
      |> Enum.filter(& &1)
      |> Enum.uniq()
      |> Map.new(&{take_prefix(&1, "/wiki/"), &1})
  end

  def take_prefix(string, prefix) do
    base = byte_size(prefix)
    binary_part(string, base, byte_size(string) - base)
  end

  def compare(start_word, last_word) do
    similar_links_list =
      Enum.map(start_word, fn({k, _v}) ->
        [ last_word[k] | []]
      end)
      |> List.flatten()
      |> Enum.filter(& &1)
    build_link(@link_word_map.link ++ similar_links_list)
  end

  def build_link(list_of_items \\ []) do
    Enum.each(list_of_items, fn(item) ->
      test = spawn fn -> HTTPoison.get(@url_base_link <> "#{item}")

      end

      IEx.pry
    end)
  end

end
