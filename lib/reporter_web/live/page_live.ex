defmodule ReporterWeb.PageLive do
  use ReporterWeb, :live_view
  alias Reporter.Incidents

  @impl true
  def mount(_params, _session, socket) do
    page = Incidents.all()

    {:ok, assign(socket, page: page)}
  end
end
