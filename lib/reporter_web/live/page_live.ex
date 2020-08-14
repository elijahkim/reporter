defmodule ReporterWeb.PageLive do
  use ReporterWeb, :live_view
  alias Reporter.Incidents

  @impl true
  def mount(_params, _session, socket) do
    %{entries: entries, page_size: page_size, page_number: page_number} = Incidents.all()

    socket = assign(socket, entries: entries, page: page_number, page_size: page_size)

    {:ok, socket, temporary_assigns: [entries: []]}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    %{page_size: page_size, page: page} = socket.assigns

    %{entries: entries, page_size: page_size, page_number: page} =
      Incidents.all(page_size: page_size, page: page + 1)

    socket = assign(socket, entries: entries, page: page, page_size: page_size)
    {:noreply, socket}
  end
end
