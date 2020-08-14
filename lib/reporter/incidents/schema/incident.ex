defmodule Reporter.Incidents.Schema.Incident do
  use Reporter.Schema

  schema "incidents" do
    field :source, :string
    field :description, :string
    field :title, :string
    field :image, :string
    field :approved_at, :naive_datetime_usec

    timestamps()
  end

  def new_changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:source])
  end

  def changeset(incident, params) do
    incident
    |> cast(params, [:description, :title, :image])
  end

  def approve_changeset(incident) do
    incident
    |> cast(%{}, [])
    |> put_change(:approved_at, NaiveDateTime.utc_now())
  end
end
