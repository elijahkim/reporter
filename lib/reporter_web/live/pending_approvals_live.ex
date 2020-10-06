defmodule ReporterWeb.PendingApprovalsLive do
  use ReporterWeb, :live_view
  alias Reporter.Incidents

  @impl true
  def mount(_params, _session, socket) do
    %{entries: entries, page_size: page_size, page_number: page_number} = Incidents.pending()

    socket = assign(socket, entries: entries, page: page_number, page_size: page_size)

    {:ok, socket}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    %{page_size: page_size, page: page, entries: entries} = socket.assigns

    %{entries: new_entries, page_size: page_size, page_number: page} =
      Incidents.pending(page_size: page_size, page: page + 1)

    entries = Enum.concat(new_entries, entries)

    socket = assign(socket, entries: entries, page: page, page_size: page_size)
    {:noreply, socket}
  end

  @impl true
  def handle_event("reject", %{"id" => id}, socket) do
    %{entries: entries} = socket.assigns
    incident = Enum.find(entries, &(&1.id == id))

    case Incidents.reject(incident) do
      {:ok, incident} ->
        entries = Enum.reject(entries, &(&1.id == id))
        socket = put_flash(socket, :info, "Rejected #{incident.id}")

        {:noreply, assign(socket, entries: entries)}
    end
  end

  @impl true
  def handle_event("approve", %{"id" => id}, socket) do
    %{entries: entries} = socket.assigns
    incident = Enum.find(entries, &(&1.id == id))

    case Incidents.approve(incident) do
      {:ok, _incident} ->
        entries = Enum.reject(entries, &(&1.id == id))

        {:noreply, assign(socket, entries: entries)}
    end
  end
end
