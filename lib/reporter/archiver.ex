defmodule Reporter.Events.Archiver do
  use GenServer
  alias Reporter.Incidents.Schema.Incident
  alias Reporter.Repo

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def process(event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  def init(_args) do
    EventBus.subscribe({__MODULE__, [".*"]})
    {:ok, %{}}
  end

  # if your subscriber does not have a config
  def handle_cast({:incident_created, _id} = event_shadow, state) do
    event = EventBus.fetch_event(event_shadow)
    %{ref: ref} = Task.async(fn -> cache_metadata(event.data) end)
    state = Map.put(state, ref, event_shadow)

    {:noreply, state}
  end

  def handle_info({ref, _value}, state) do
    event_shadow = Map.get(state, ref)
    EventBus.mark_as_completed({__MODULE__, event_shadow})
    state = Map.delete(state, ref)

    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, _, :normal}, state) do
    {:noreply, state}
  end

  def cache_metadata(incident) do
    properties = incident |> get_properties()

    incident
    |> Incident.changeset(properties)
    |> Repo.update()
  end

  defp get_properties(%{source: source}) do
    {:ok, %{body: body}} = Mojito.get(source)
    {:ok, document} = Floki.parse_document(body)

    ["og:description", "og:image", "og:title"]
    |> Map.new(fn attr ->
      value =
        Floki.find(document, "meta[property='#{attr}']")
        |> get_content()

      "og:" <> attr = attr

      {String.to_existing_atom(attr), value}
    end)
  end

  defp get_content(fragment) do
    {"meta", tags, []} = List.first(fragment)

    Enum.find(tags, fn tag ->
      case tag do
        {"content", content} -> content
        _ -> false
      end
    end)
    |> elem(1)
  end
end
