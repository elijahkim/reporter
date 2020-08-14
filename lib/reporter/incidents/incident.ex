defmodule Reporter.Incidents do
  use EventBus.EventSource

  alias Reporter.Repo
  alias Reporter.Incidents.Schema.Incident

  import Ecto.Query

  def all(opts \\ []) do
    from(
      i in Incident,
      where: not is_nil(i.approved_at),
      order_by: [desc: i.inserted_at]
    )
    |> Repo.paginate(opts)
  end

  def pending(opts \\ []) do
    from(
      i in Incident,
      order_by: [desc: i.inserted_at]
    )
    |> Repo.paginate(opts)
  end

  def create(params) do
    params
    |> Incident.new_changeset()
    |> Repo.insert()
    |> notify(:create_incident)
  end

  def approve(interest) do
    interest
    |> Incident.approve_changeset()
    |> Repo.update()
    |> notify(:approve_incident)
  end

  defp notify({:ok, incident} = res, :approve_incident) do
    %{
      id: Ecto.UUID.generate(),
      topic: :incident_approved,
      data: incident
    }
    |> EventSource.build do
      incident
    end
    |> EventBus.notify()

    res
  end

  defp notify({:ok, incident} = res, :create_incident) do
    %{
      id: Ecto.UUID.generate(),
      topic: :incident_created,
      data: incident
    }
    |> EventSource.build do
      incident
    end
    |> EventBus.notify()

    res
  end

  defp notify(result, _), do: result
end
