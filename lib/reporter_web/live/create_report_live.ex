defmodule ReporterWeb.CreateReportLive do
  use ReporterWeb, :live_view
  alias Reporter.Incidents.Schema.Incident
  alias Reporter.Incidents

  @impl true
  def mount(_params, _session, socket) do
    changeset = Incident.new_changeset()

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", changes, socket) do
    changeset = Incident.new_changeset(changes)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"incident" => incident}, socket) do
    incident
    |> Incidents.create()
    |> case do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Thank you. Your report has been submitted for approval")
          |> push_redirect(to: "/")

        {:noreply, socket}
    end
  end
end
