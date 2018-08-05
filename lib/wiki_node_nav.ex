defmodule Wiki do
  require IEx
  @url_base_link "https://en.wikipedia.org/wiki/"
  @url "https://en.wikipedia.org"
  @wiki_black_list ~w(/wiki/File: /wiki/Category: /wiki/Special: /wiki/Wikipedia: /wiki/Portal: /wiki/Talk: /wiki/Help: /wiki/Main_Page)
  @link_word_map %{link: []}

  def get_links(params) do
    start_word =
      HTTPoison.get(@url_base_link <> "#{params["start_word"]}")
      |> process_response_body()

    last_word =
      HTTPoison.get(@url_base_link <> "#{params["last_word"]}")
      |> process_response_body()

    # IEx.pry


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

    dispatch_to_task(@link_word_map.link ++ similar_links_list)
  end

  def build_link(item) do

    slice_string = String.slice(item, 1..-1)

    get_request = HTTPoison.get(@url <> "#{slice_string}")



    # target = self()

    # spawn(fn ->
    #   # write stuff to disk
    #   # takes long time

    # # send a message to it
    #   send(target, result_of_write)

    # end)

    # dispatch_to_task(list_of_items)
    # target = self()
    #  spawn(fn ->
    #   link = Enum.reduce(list_of_items, %{}, fn(item, acc) ->
    #     get_request = HTTPoison.get(@url_base_link <> "#{item}")

    #     IEx.pry

    #   end)

    #   send(target, link)
    # end)
      end

  defp dispatch_to_task(list_of_items \\ []) do
    test =
      list_of_items
      |> Enum.map(&Task.async(fn -> build_link(&1) end))
      |> Enum.map(&Task.await(&1))

    IEx.pry

  end

end
